//
//  CSession.m
//  MultiTerminal
//
//  Created by Jonathan Wight on 1/21/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CShellSession.h"

@implementation CShellSession

- (id)initWithURL:(NSURL *)inURL
    {
    if ((self = [super init]) != NULL)
        {
        _URL = inURL;
        _title = _URL.lastPathComponent;
        _status = 0;
        }
    return self;
    }

#pragma mark -

- (void)encodeWithCoder:(NSCoder *)aCoder
    {
    [aCoder encodeObject:self.URL forKey:@"URL"];
    }

- (id)initWithCoder:(NSCoder *)aDecoder
    {
    if ((self = [super init]) != NULL)
        {
        _URL = [aDecoder decodeObjectForKey:@"URL"];
        _title = _URL.lastPathComponent;
        }
    return self;
    }

#pragma mark -

- (BOOL)runScript:(NSString *)inScript handler:(void (^)(int))inHandler;
    {
    self.processing = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSPipe *theOutputPipe = [NSPipe pipe];

        NSTask *theTask = [[NSTask alloc] init];
        theTask.launchPath = @"/bin/bash";
        theTask.arguments = @[@"--login",
            @"-c",
            inScript];
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
