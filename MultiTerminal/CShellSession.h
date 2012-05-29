//
//  CSession.h
//  MultiTerminal
//
//  Created by Jonathan Wight on 1/21/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CShellSession : NSObject

@property (readwrite, nonatomic, strong) NSURL *URL;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, strong) NSString *output;
@property (readwrite, nonatomic, assign) NSInteger status;
@property (readwrite, nonatomic, assign) BOOL processing;

- (id)initWithURL:(NSURL *)inURL;
- (BOOL)runScript:(NSString *)inScript handler:(void (^)(int))inHandler;

@end
