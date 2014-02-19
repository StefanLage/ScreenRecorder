//
//  SRRecorder.h
//  ScreenRecorder
//
//  Created by Stefan Lage on 19/02/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SRRecorder : NSObject <AVCaptureFileOutputRecordingDelegate>{
    AVCaptureSession *srSession;
    AVCaptureMovieFileOutput *srOutput;
    NSURL *filePath;
    NSString *fileName;
}

-(id)initWithUrl:(NSString*)url;
-(void)startRecording;
-(void)stopRecording;

@end
