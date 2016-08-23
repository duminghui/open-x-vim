//
//  StatusBarMenu.m
//  OpenDemo
//
//  Created by dumh on 16/8/22.
//  Copyright © 2016年 dumh. All rights reserved.
//

#import "StatusBarMenu.h"
#import "AppSettings.h"

@interface StatusBarMenu(){
  AppSettings * settings;
  NSMenuItem * vimItem;
  NSMenuItem * neoVimItem;
  NSMenuItem * useTmuxItem;
}

@end

@implementation StatusBarMenu
@synthesize statusItem;

-(id)init{
  self = [super initWithTitle:@"StatusBar Menu"];
  if(self){
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    statusItem.menu=self;
    
    settings = [AppSettings sharedInstance];
    
    useTmuxItem = [[NSMenuItem alloc]initWithTitle:@"Tmux" action:nil keyEquivalent:@""];
    useTmuxItem.target = self;
    useTmuxItem.action = @selector(toggleUseTmux);
    [self addItem:useTmuxItem];
    
    [self addItem: [NSMenuItem separatorItem]];
    
    vimItem = [[NSMenuItem alloc] initWithTitle:@"Vim" action:nil keyEquivalent:@""];
    vimItem.target=self;
    vimItem.action = @selector(selectVimEditor);
    [self addItem:vimItem];
    
    neoVimItem = [[NSMenuItem alloc]initWithTitle:@"NeoVim" action:nil keyEquivalent:@""];
    neoVimItem.target =  self;
    neoVimItem.action = @selector(selectNeoVimEditor);
    [self addItem:neoVimItem];
    
    [self addItem: [NSMenuItem separatorItem]];
    
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:nil keyEquivalent:@""];
    quitItem.target = [NSApplication sharedApplication];
    quitItem.action = @selector(terminate:);
    [self addItem:quitItem];
    
    if([settings isVimEditor]){
      vimItem.state = NSOnState;
      neoVimItem.state = NSOffState;
      statusItem.image = [NSImage imageNamed:@"statusbar_icon_vim"];
    }else{
      vimItem.state = NSOffState;
      neoVimItem.state = NSOnState;
      statusItem.image = [NSImage imageNamed:@"statusbar_icon_neovim"];
    }
    
    if([settings useTmux]){
      useTmuxItem.state = NSOnState;
    }
  }
  return self;
}

-(void)toggleUseTmux{
  if([settings useTmux]){
    [settings setUseTmux:false];
    useTmuxItem.state = NSOffState;
  }else{
    [settings setUseTmux:true];
    useTmuxItem.state = NSOnState;
  }
}

-(void)selectVimEditor{
  vimItem.state =  NSOnState;
  [settings setVimEditor];
  neoVimItem.state = NSOffState;
  statusItem.image = [NSImage imageNamed:@"statusbar_icon_vim"];
}

-(void)selectNeoVimEditor{
  neoVimItem.state = NSOnState;
  [settings setNeoVimEditor];
  vimItem.state = NSOffState;
  statusItem.image = [NSImage imageNamed:@"statusbar_icon_neovim"];
}

@end
