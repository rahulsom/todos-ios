//
// Created by Rahul Somasunderam on 6/26/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import "TodoService.h"
#import "Todo.h"
#import "ReactiveCocoa.h"
#import "BlocksKit.h"


@implementation TodoService {
    NSMutableArray <Todo> *_data;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *storedData = self.load;
        _data = (NSMutableArray <Todo> *) (storedData ? storedData: [self defaultTasks]).mutableCopy;
        NSLog(@"At init, Data is: %@", _data);
    }
    return self;
}

- (NSArray *)defaultTasks {
    NSLog(@"Loading defaults...");
    return @[
            [Todo todoWithText:@"Let's get started"],
            [Todo todoWithText:@"This is a TODO"],
            [Todo todoWithText:@"And here's one more" done:YES],
    ];
}

- (void)add:(NSString *)text {
    [_data addObject:[Todo todoWithText:text]];
    [self save];
}

- (NSArray <Todo> *)list {
    return _data;
}

- (void)save {
    if (_data) {
        NSArray *array = [[[_data
                rac_sequence]
                map:^id(Todo *value) {
                    return @{@"text" : value.text, @"done" : @(value.done)};
                }]
                array];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"Data"];
        NSLog(@"Saved Data");
    }
}

- (void)clearDone {

    [_data bk_performReject:^BOOL(Todo *obj) {
        return obj.done;
    }];
    [self save];
    NSLog(@"After clear, Data is: %@", _data);
}

- (NSArray *)load {
    NSArray *stored = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Data"];
    NSArray *array = [[[stored
            rac_sequence]
            map:^id(NSDictionary *value) {
                NSNumber *done = (NSNumber *) value[@"done"];
                return [Todo todoWithText:value[@"text"] done:done.boolValue];
            }]
            array];
    NSLog(@"After load, The array is: %@", array);
    return array;
}


@end