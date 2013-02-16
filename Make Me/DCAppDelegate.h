//
//  DCAppDelegate.h
//  Make Me
//
//  Created by Devin Coughlin on 8/14/12.
//  Copyright (c) 2012 Devin Coughlin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TerminalTab;

@interface DCAppDelegate : NSObject <NSApplicationDelegate> {
    
    NSStatusItem *statusItem;
    
    TerminalTab *currentTerminalTab;
}

@property (assign) IBOutlet NSWindow *window;


@property (assign) IBOutlet NSMenu *statusMenu;



-(IBAction)makeMe:(id)sender;

@end
