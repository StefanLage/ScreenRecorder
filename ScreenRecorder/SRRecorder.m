//
//  SRRecorder.m
//  ScreenRecorder
//
//  Created by Stefan Lage on 19/02/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "SRRecorder.h"

#define DESTINATION_PATH        [NSString stringWithFormat:@"%@/Movies/ScreenRecorder/", NSHomeDirectory()]
#define FILENAME                @"ScreenRecorder"

@implementation SRRecorder

-(id)init{
    self = [super init];
    if(self){
        filePath = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/%@.mov", DESTINATION_PATH, FILENAME]];
        [self checkDestPath:[NSURL URLWithString:DESTINATION_PATH]];
    }
    return self;
}

-(id)initWithUrl:(NSString*)fileExtension{
    self = [super init];
    if(self){
        filePath = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/%@.%@", DESTINATION_PATH, FILENAME, fileExtension]];
        [self checkDestPath:[NSURL URLWithString:DESTINATION_PATH]];
    }
    return self;
}

// Check if the destination exist
// If not we create it
-(void)checkDestPath:(NSURL *)destPath{
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:[destPath path] isDirectory:&isDirectory]){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtURL:destPath withIntermediateDirectories:NO attributes:nil error:&error];
        if(error)
            NSLog(@"CANNOT CREATE DIRECTORY");
    }
}

-(void)startRecording{
    // Create a capture session
    srSession = [[AVCaptureSession alloc] init];
    // Set the session preset as you wish
    srSession.sessionPreset = AVCaptureSessionPresetHigh;
    // Selected MainScreen
    CGDirectDisplayID displayId = kCGDirectMainDisplay;
    // Set Main screen as ScreenInput
    AVCaptureScreenInput *input = [[AVCaptureScreenInput alloc] initWithDisplayID:displayId];
    if (!input) {
        srSession = nil;
        return;
    }
    if ([srSession canAddInput:input])
        [srSession addInput:input];
    // Create the OutPut file
    srOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([srSession canAddOutput:srOutput])
        [srSession addOutput:srOutput];
    // Start running the session
    [srSession startRunning];
    // Be sure the movie does not exist -> if yes delete it
    if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[filePath path] error:&err])
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
    }
    // Start recording to the destination movie file
    [srOutput startRecordingToOutputFileURL:filePath recordingDelegate:self];
}

-(void)stopRecording{
    // Stop recording to the destination movie file
    [srOutput stopRecording];
    NSLog(@"Stop Recording");
}

// AVCaptureFileOutputRecordingDelegate methods
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    // Stop running the session
    [srSession stopRunning];
    srSession = nil;
}

@end
