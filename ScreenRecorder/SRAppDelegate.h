//
//  SRAppDelegate.h
//  ScreenRecorder
//
//  Created by Stefan Lage on 19/02/14.
//  Copyright (c) 2014 Stefan Lage. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SRRecorder.h"

// Enum to define an ID for each extension
typedef enum : int {
    avi = 0,
    mov = 1,
    mp4 = 2
} SRExtension;

@interface SRAppDelegate : NSObject <NSApplicationDelegate>{
    NSStatusItem * recorderItem;
    BOOL isRecording;
    NSDictionary *extensions;
    int tagItemSelected;
    NSString *extensionSelected;
}

@property (weak, nonatomic) SRRecorder *record;
@property (weak) IBOutlet NSMenu *SRRecorderMenu;
@property (weak) IBOutlet NSMenu *fileExtensions;
@property (weak) IBOutlet NSMenuItem *startStopButton;

- (IBAction)startStopRecording:(id)sender;
- (IBAction)quit:(id)sender;

@end
