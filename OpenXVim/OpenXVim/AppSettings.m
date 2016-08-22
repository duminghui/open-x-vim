//
//  AppSettings.m
//  OpenDemo
//
//  Created by dumh on 16/8/21.
//  Copyright © 2016年 dumh. All rights reserved.
//

#import "AppSettings.h"
#import <Cocoa/Cocoa.h>

@implementation AppSettings

NSString *const KEY_EDITOR = @"EDITOR";
NSString *const KEY_USE_TMUX = @"USE_TMUX";

NSUserDefaults *prefs;

#pragma mark Creating singleton or object
+ (instancetype)sharedInstance
{
  static dispatch_once_t once;
  static NSMutableDictionary * __strong sharedInstances;
  dispatch_once(&once, ^ { sharedInstances = [[NSMutableDictionary alloc] init]; });
  NSString * className = NSStringFromClass([self class]);
  id theSharedInstance = nil;
  if ([className length] > 0 && sharedInstances) {
    theSharedInstance = sharedInstances[className];
    if (!theSharedInstance) {
      theSharedInstance = [[[self class] alloc] init];
      sharedInstances[className] = theSharedInstance;
    }
  }
  return theSharedInstance;
}

-(id)init{
  self = [super init];
  if(self){
    prefs = [NSUserDefaults standardUserDefaults];
    [self loadSettings];
  }
  return self;
}

-(void)setVimEditor{
  [self setEditor:@"vim"];
}

-(void)setNeoVimEditor{
  [self setEditor:@"nvim"];
}

-(BOOL)isVimEditor{
  return [_editor isEqual:@"vim"];
}

-(void)setEditor:(NSString *)editor{
  _editor = editor;
  [self saveSettings];
}

-(NSString*)editor{
  return _editor;
}

-(void)setUseTmux:(BOOL)useTmux{
  _useTmux = useTmux;
  [self saveSettings];
}

-(BOOL)useTmux{
  return _useTmux;
}

-(void)loadSettings{
  _editor = [prefs stringForKey:KEY_EDITOR];
  if(_editor == nil){
    _editor = @"vim";
  }
  id tmpUseTmux=[prefs objectForKey:KEY_USE_TMUX];
  if(!tmpUseTmux){
    _useTmux = TRUE;
  }else{
    _useTmux = [prefs boolForKey:KEY_USE_TMUX];
  }
}

-(void)saveSettings{
  [prefs setObject:_editor forKey:KEY_EDITOR];
  [prefs setBool:_useTmux forKey:KEY_USE_TMUX];
  [prefs synchronize];
}

@end
