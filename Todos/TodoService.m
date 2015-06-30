//
// Created by Rahul Somasunderam on 6/26/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import "TodoService.h"
#import "Todo.h"
#import "ReactiveCocoa.h"


@implementation TodoService {
    NSMutableArray <Todo> *data;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        data = (NSMutableArray <Todo> *) (self.load ?: @[
                [Todo todoWithText:@"Let's get started"],
                [Todo todoWithText:@"This is a TODO"],
                [Todo todoWithText:@"And here's one more" done:YES],
        ].mutableCopy);
        NSLog(@"Data is: %@", data);
    }
    return self;
}

- (void)add:(NSString *)text {
    [data addObject:[Todo todoWithText:text]];
}

- (NSArray <Todo> *)list {
    return data;
}

- (void)save {
    if (data) {
        NSArray *array = [[data
                    rac_sequence]
                    map:^id(Todo *value) {
                        return @{@"text":value.text, @"done": @(value.done)};
                    }].array;
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"Data"];
    }
}

- (NSArray *)load {
    NSArray *stored = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Data"];
    NSArray *array = [[stored
            rac_sequence]
            map:^id(NSDictionary *value) {
                return [Todo todoWithText:value[@"text"] done:((NSNumber *)(value[@"done"])).boolValue];
            }].array;
    NSLog(@"The array is: %@", array);
    return array;
}


@end