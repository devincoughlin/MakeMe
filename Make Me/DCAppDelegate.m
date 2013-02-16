//
//  DCAppDelegate.m
//  Make Me
//
//  Created by Devin Coughlin on 8/14/12.
//  Copyright (c) 2012 Devin Coughlin. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "DCAppDelegate.h"

#import "Terminal.h"
#import "SystemEvents.h"
#import "BBEdit.h"

@interface DCAppDelegate ()

-(void)registerHotKey;

@end

@implementation DCAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)awakeFromNib; {
    
 	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	

    
	[statusItem setHighlightMode:YES];
    [statusItem setTitle:@"Make Me"];
	
	[statusItem setMenu:self.statusMenu];
	
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self registerHotKey];
}


-(IBAction)makeMe:(id)sender {
    NSLog(@"Make Me!");

    TerminalApplication *terminalApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.Terminal"];
    
    
  
    BBEditApplication *bbeditApp = [SBApplication applicationWithBundleIdentifier:@"com.barebones.bbedit"];
    
    SBElementArray *textDocuments = bbeditApp.textDocuments;
    
    if (textDocuments.count > 0) {
        BBEditTextDocument *textDocument = [textDocuments objectAtIndex:0];
        
        NSURL *fileURL = textDocument.file;
    
        
        NSString *path = [fileURL path];

        NSLog(@"path of document is %@", path);
        
        NSString *parentOfDocument = [[path stringByStandardizingPath] stringByDeletingLastPathComponent];
        
        NSString *command = [NSString stringWithFormat:@"cd '%@' && ./make.sh || tput bel", parentOfDocument];
        
        if (![currentTerminalTab exists]) {
            [currentTerminalTab release];
            currentTerminalTab = nil;
        }
        
        TerminalTab *newTerminalTab = [terminalApp doScript:command in:currentTerminalTab];
        
        [currentTerminalTab release];
        currentTerminalTab = [newTerminalTab retain];
        
        NSLog(@"Done");
    }
   /* 
    
    SystemEventsApplication *systemEventsApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.systemevents"];
    
    for (SystemEventsApplicationProcess *process in [systemEventsApp applicationProcesses]) {
        
        if ([process frontmost]) {
            NSLog(@"FrontMostApp:%@", [process displayedName]);
            
            
        
            SBElementArray *windows = [process windows];
            
            if ([windows count] > 0) {
                SystemEventsWindow *window = [windows objectAtIndex:0];
                
                SystemEventsDocument *document = window.document;
                
                if (document != nil) {
                    NSString *path = document.path;
                    
                    NSLog(@"Path is %@; name is %@", path, document.name);
                }
            }
        }
         
    }
    
    */
    
    
    
}

OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,
                         void *userData)
{
    EventHotKeyID hkCom;
    GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,
                      sizeof(hkCom),NULL,&hkCom);
    int l = hkCom.id;
    
    switch (l) {
        case 1: //do something
            NSLog(@"Got hot key");
            [(DCAppDelegate *)[NSApp delegate] makeMe:nil];
            break;
        case 2: //do something
            break;
    }
    return noErr;
}

- (void)registerHotKey; {
    EventHotKeyRef gMyHotKeyRef;
    EventHotKeyID gMyHotKeyID;
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;

    
    InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,NULL,NULL);

    gMyHotKeyID.signature='htk1';
    gMyHotKeyID.id=1;
    
    //Control command option space
    RegisterEventHotKey(49, controlKey + cmdKey+optionKey, gMyHotKeyID,
                        GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}

@end
