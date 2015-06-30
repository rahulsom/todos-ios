//
// Created by Rahul Somasunderam on 6/26/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import "TodoService.h"
#import "Todo.h"


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
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Data"];
}

- (NSArray *)load {
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Data"];
    NSLog(@"The array is: %@", array);
    return array;
}


@end