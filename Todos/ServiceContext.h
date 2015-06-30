//
// Created by Rahul Somasunderam on 6/30/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TodoService;


@interface ServiceContext : NSObject
- (TodoService *)todoService;

+(ServiceContext *) instance;
@end