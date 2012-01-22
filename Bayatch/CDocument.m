//
//  CDocument.m
//  Bayatch
//
//  Created by Jonathan Wight on 1/21/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CDocument.h"

#import "CDirectory.h"
#import "CBlockValueTransformer.h"

@interface CDocument ()
@property (readwrite, nonatomic, strong) NSArray *directories;
@property (readwrite, nonatomic, strong) IBOutlet NSArrayController *sessionsController;
@property (readwrite, nonatomic, strong) NSString *script;
@property (readwrite, nonatomic, strong) IBOutlet NSTextView *outputTextView;
@end

#pragma mark -

@implementation CDocument

@synthesize directories;
@synthesize sessionsController;
@synthesize script;
@synthesize outputTextView;

+ (void)initialize
    {
    [NSValueTransformer setValueTransformerForName:@"xyzzy" block:^id(id value)
        {
        if ([value intValue] == NO)
            {
            return([NSImage imageNamed:@"CellBackgroundDefault.png"]);
            }
        else
            {
            return([NSImage imageNamed:@"CellBackground.png"]);
            }
        }];
    }

+ (BOOL)autosavesInPlace
    {
    return YES;
    }
    

- (NSString *)windowNibName
    {
    return @"CDocument";
    }

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
    {
    [super windowControllerDidLoadNib:aController];

    self.outputTextView.font = [NSFont fontWithName:@"Menlo" size:13];


    NSMutableArray *theDirectories = [NSMutableArray array];
    
    NSURL *theURL = [NSURL fileURLWithPath:@"/Users/schwa/Development/Source/Git/Projects/• Old"];
    NSError *theError = NULL;
    NSArray *theContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:theURL includingPropertiesForKeys:NULL options:NSDirectoryEnumerationSkipsHiddenFiles error:&theError];
    for (NSURL *theURL in theContents)
        {
        NSNumber *theFlag;
        [theURL getResourceValue:&theFlag forKey:NSURLIsDirectoryKey error:&theError];
        if (theFlag.boolValue == YES)
            {
            CDirectory *theSession = [[CDirectory alloc] initWithURL:theURL];
            [theDirectories addObject:theSession];
            }
        }

    self.directories = [theDirectories copy];
    }

- (IBAction)runScript:(id)sender
    {
    NSLog(@"RUN SCRIPT: %@", self.script);

    

    for (CDirectory *theSession in self.sessionsController.selectedObjects)
        {
        [theSession runScript:self.script handler:NULL];
        }
    }

@end
