//
// Created by Rahul Somasunderam on 6/26/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Todo

@end

@interface Todo : NSObject

@property(nonatomic, strong) NSString *text;
@property(nonatomic) BOOL done;

- (NSString *)description;

- (instancetype)initWithText:(NSString *)text done:(BOOL)done;
- (instancetype)initWithText:(NSString *)text;

+ (instancetype)todoWithText:(NSString *)text done:(BOOL)done;
+ (instancetype)todoWithText:(NSString *)text;

@end