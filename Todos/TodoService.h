//
// Created by Rahul Somasunderam on 6/26/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol Todo;

@interface TodoService : NSObject

- (void) add: (NSString *)text;
- (NSArray<Todo> *) list;
- (void) save;
- (void)clearDone;

@end