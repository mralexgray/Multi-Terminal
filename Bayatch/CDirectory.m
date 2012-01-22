//
//  CSession.m
//  Bayatch
//
//  Created by Jonathan Wight on 1/21/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CDirectory.h"

@implementation CDirectory

@synthesize URL;
@synthesize title;
@synthesize output;
@synthesize status;
@synthesize processing;

- (id)initWithURL:(NSURL *)inURL
    {
    if ((self = [super init]) != NULL)
        {
        URL = inURL;
        title = inURL.lastPathComponent;
        status = 0;
        }
    return self;
    }

- (BOOL)runScript:(NSString *)inScript handler:(void (^)(int))inHandler;
    {
    self.processing = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSPipe *theOutputPipe = [NSPipe pipe];

        NSTask *theTask = [[NSTask alloc] init];
        theTask.launchPath = @"/bin/bash";
        theTask.arguments = [NSArray arrayWithObjects:
            @"--login",
            @"-c",
            inScript,
            NULL];
        theTask.currentDirectoryPath = self.URL.path;    

//TERM_PROGRAM=Apple_Terminal
//TERM=xterm-256color
//SHELL=/bin/bash
//TMPDIR=/var/folders/c9/pqvs14g940j9q5dxgh8njsnh0000gn/T/
//Apple_PubSub_Socket_Render=/tmp/launch-kPmlcb/Render
//TERM_PROGRAM_VERSION=299
//TERM_SESSION_ID=BBC564E6-C87C-44CE-A058-D86F2CE73C56
//PYTHONUSERBASE=/Users/schwa/Library/Python
//HISTFILESIZE=10000
//USER=schwa
//COMMAND_MODE=unix2003
//SSH_AUTH_SOCK=/tmp/launch-hbR2Cm/Listeners
//__CF_USER_TEXT_ENCODING=0x1F5:0:0
//LSCOLORS=cxbxFxFxFxFxxxxxxxxxxx
//PYTHONBIN=/Users/schwa/Library/Python/bin
//PATH=/Users/schwa/bin:/Users/schwa/Library/Python/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local/mysql/bin:/Developer/Tools:/Developer/usr/bin::/Users/schwa/.gem/ruby/1.8/bin
//PWD=/Users/schwa
//EDITOR=bbedit -w
//HOMEBREW_LLVM=1
//LANG=en_US.UTF-8
//PYTHONSTARTUP=/Users/schwa/.pythonrc
//NODE_PATH=/usr/local/lib/node
//PS1=[\u@\h] \W$ 
//SHLVL=1
//HOME=/Users/schwa
//PYTHONPATH=:/Library/Python:/Users/schwa/Library/Python/User
//LOGNAME=schwa
//DISPLAY=/tmp/launch-vGD7bl/org.x:0
//RUBYBIN=/Users/schwa/.gem/ruby/1.8/bin
//_=/usr/bin/env



        theTask.environment = [NSDictionary dictionaryWithObjectsAndKeys:
            @"xterm-256color", @"TERM",
            @"unix2003", @"COMMAND_MODE",
//            @"en_US,UTF-8", @"LANG",
            @"C", @"LANG",
            NULL];

        theTask.standardInput = [NSPipe pipe];
        theTask.standardError = theOutputPipe;
        theTask.standardOutput = theOutputPipe;

        [theTask launch];
        NSData *theData = [theOutputPipe.fileHandleForReading readDataToEndOfFile];
        [theTask waitUntilExit];
        
        self.status = theTask.terminationStatus;
        

        

        NSString *theString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.output = theString;
            self.processing = NO;
            });
        });
    
//    - (void)setLaunchPath:(NSString *)path;
//- (void)setArguments:(NSArray *)arguments;
//- (void)setEnvironment:(NSDictionary *)dict;
//	// if not set, use current
//- (void)setCurrentDirectoryPath:(NSString *)path;

    
    
    
    return(YES);
    }

@end
