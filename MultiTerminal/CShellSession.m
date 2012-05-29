//
//  CSession.m
//  MultiTerminal
//
//  Created by Jonathan Wight on 1/21/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CShellSession.h"

@implementation CShellSession

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

        NSMutableDictionary *theEnvironment = [[NSProcessInfo processInfo].environment copy];
//[theEnvironment addEntriesFromDictionary:<#(NSDictionary *)#>
//
//        theTask.environment = [NSDictionary dictionaryWithObjectsAndKeys:
//            @"xterm-256color", @"TERM",
//            @"unix2003", @"COMMAND_MODE",
////            @"en_US,UTF-8", @"LANG",
//            @"C", @"LANG",
//            NULL];

        theTask.environment = theEnvironment;
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
    
    return(YES);
    }

@end
