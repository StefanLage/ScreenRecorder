//
//  SRAppDelegate.m
//  ScreenRecorder
//
//  Created by Stefan Lage on 19/02/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import "SRAppDelegate.h"

@implementation SRAppDelegate

@synthesize record;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
}

-(void)awakeFromNib{
    [self addExtension];
    recorderItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [recorderItem setMenu:self.SRRecorderMenu];
    [self setRecordPicture];
    [recorderItem setHighlightMode:YES];
}

// Add all extension in Menu list
-(void)addExtension{
    extensions = @{
                   [NSNumber numberWithInt:avi] : @"avi",
                   [NSNumber numberWithInt:mov] : @"mov",
                   [NSNumber numberWithInt:mp4] : @"mp4"
                   };
    for (NSNumber *extension in extensions){
        NSMenuItem *item = [[NSMenuItem alloc] init];
        [item setTitle:[extensions objectForKey:extension]];
        [item setTarget:self];
        [item setAction:@selector(selectExtension:)];
        [item setTag:[extension intValue]];
        if(extension == [NSNumber numberWithInt:mov])
            // Select it by default
            [item setState:1];
        [self.fileExtensions addItem:item];
    }
}


-(void)toto{
    [self.record stopRecording];
}

// Resize an NSImage
-(NSImage *)imageResized:(NSImage*)image size:(NSSize)size{
    NSImage *sourceImage = image;
    [sourceImage setScalesWhenResized:YES];
    NSImage *smallImage = [[NSImage alloc] initWithSize: size];
    [smallImage lockFocus];
    [sourceImage setSize: size];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, size.width, size.height) operation:NSCompositeCopy fraction:1.0];
    [smallImage unlockFocus];
    return smallImage;
}

// Start or stop recording
- (IBAction)startStopRecording:(id)sender {
    if(!isRecording){
        // Start recording
        isRecording = YES;
        SRRecorder *rec;
        // No extension selected -> basic record
        if (!extensionSelected)
            rec = [[SRRecorder alloc] init];
        else
            rec = [[SRRecorder alloc] initWithUrl:extensionSelected];
        
        self.record = rec;
        [self.record startRecording];
    }else{
        // Stop it
        isRecording = NO;
        self.record = nil;
        [self.record stopRecording];
    }
    [self setRecordPicture];
}

// Kill process
- (IBAction)quit:(id)sender {
    isRecording = NO;
    exit(0);
}

-(void)setRecordPicture{
    if(isRecording){
        [recorderItem setImage:[self imageResized:[NSImage imageNamed:@"recording"] size:NSMakeSize(18, 18)]];
        [self.startStopButton setTitle:@"Stop Recording"];
    }
    else{
        [recorderItem setImage:[self imageResized:[NSImage imageNamed:@"play"] size:NSMakeSize(18, 18)]];
        [self.startStopButton setTitle:@"Start Recording"];
        
    }
}

-(void)selectExtension:(id)sender{
    [self deselectExtension];
    NSMenuItem *item = (NSMenuItem*)sender;
    tagItemSelected = (int)item.tag;
    [item setState:1];
    extensionSelected = [extensions objectForKey:[NSNumber numberWithInt:tagItemSelected]];
}

// Deselect last extension selected
-(void)deselectExtension{
    NSMenuItem *item = [self.fileExtensions itemWithTag:tagItemSelected];
    if([item state] == 1)
        [item setState:0];
}

@end
