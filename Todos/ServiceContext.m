//
// Created by Rahul Somasunderam on 6/30/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import "ServiceContext.h"
#import "TodoService.h"


@implementation ServiceContext {
    TodoService *_todoService;
}
static ServiceContext *_instance = nil;

- (instancetype)init {
    self = [super init];
    if (self) {
        _todoService = [[TodoService alloc] init];
    }

    return self;
}

- (TodoService *)todoService {
    return _todoService;
}

+ (ServiceContext *)instance {
    if (_instance == nil) {
        NSLog(@"Creating new service context");
        _instance = [[ServiceContext alloc] init];
    }
    return _instance;
}


@end