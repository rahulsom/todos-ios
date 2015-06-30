//
// Created by Rahul Somasunderam on 6/26/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import "Todo.h"


@implementation Todo 
- (instancetype)initWithText:(NSString *)text done:(BOOL)done {
    self = [super init];
    if (self) {
        self.text = text;
        self.done = done;
    }

    return self;
}

+ (instancetype)todoWithText:(NSString *)text done:(BOOL)done {
    return [[self alloc] initWithText:text done:done];
}

- (instancetype)initWithText:(NSString *)text {
    return [self initWithText:text done:NO];
}

+ (instancetype)todoWithText:(NSString *)text {
    return [[self alloc] initWithText:text];
}

- (NSString *)description {
    NSString *checkMark = self.done ? @"X": @" ";
    return [NSString stringWithFormat:@"[%@] - %@", checkMark, self.text];
}

@end