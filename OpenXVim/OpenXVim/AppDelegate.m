//
//  AppDelegate.m
//  OpenXVim
//
//  Created by dumh on 16/8/22.
//  Copyright © 2016年 dumh. All rights reserved.
//

#import "AppDelegate.h"
#import "AppSettings.h"
#import "StatusBarMenu.h"

@interface AppDelegate (){
  NSString * cmdPath;
  AppSettings * settings;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
  self.statusItem = [[StatusBarMenu alloc]init].statusItem;
  
  cmdPath = [[NSBundle mainBundle]pathForResource:@"openxvim" ofType:@""];
  
  settings = [AppSettings sharedInstance];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
  [[NSAppleEventManager sharedAppleEventManager]
   setEventHandler:self andSelector:@selector(handleAppleEvent:withReplyEvent:)
   forEventClass:'aevt' andEventID:'odoc'];
}

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
  NSData *eventData = [event data];
  unsigned char *buffer = malloc(sizeof(UInt16));
  [eventData getBytes: buffer range:NSMakeRange(422, sizeof(UInt16))];
  UInt16 x = *(UInt16 *)buffer;
  if (x == ((UInt16)65534)) {
    x = 0;
  }
  // check to see if Unity didn't pass in a line
  if(x >= 17477) {
    x = 0;
  }
  
  NSString *filepath = [[[event descriptorForKeyword:keyDirectObject] stringValue] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
  filepath = [filepath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [self openFile:filepath lineNum:x];
}

-(void)openFile:(NSString*)filepath lineNum:(UInt16) lineNum{
  NSLog(@"cmdPath: %@",cmdPath);
  NSLog(@"editor:%@,useTmux:%hhd",[settings editor],[settings useTmux]);
  NSLog(@"filepath: %@:%d",filepath,lineNum);
  NSPipe *pipe = [NSPipe pipe];
  NSFileHandle * file = pipe.fileHandleForReading;
  NSTask *task = [[NSTask alloc] init];
  task.launchPath = cmdPath;
  NSString * options = @"";
  if(lineNum > 0 ){
    options = [NSString stringWithFormat:@"+normal %dG1|",lineNum+1];
  }
  task.arguments = @[filepath,
                     options,
                     [settings editor],
                     [NSString stringWithFormat:@"%hhd",[settings useTmux]]
                     ];
  task.standardOutput = pipe;
  [task launch];
  NSData *data = [file readDataToEndOfFile];
  [file closeFile];
  NSString *cmdOutput=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"openxvim result: \n%@",cmdOutput );
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
  NSLog(@"openFile: %@",filename);
  return TRUE;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

@end
