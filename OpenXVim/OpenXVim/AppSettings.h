//
//  AppSettings.h
//  OpenDemo
//
//  Created by dumh on 16/8/21.
//  Copyright © 2016年 dumh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject{
  NSString * _editor;
  BOOL _useTmux;
}

+ (instancetype)sharedInstance;

-(void)setVimEditor;
-(void)setNeoVimEditor;
-(BOOL)isVimEditor;
-(NSString*)editor;

-(void)setUseTmux:(BOOL)useTmux;
-(BOOL)useTmux;

-(void)saveSettings;
-(void)loadSettings;

@end
