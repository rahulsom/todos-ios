//
//  ViewController.m
//  Todos
//
//  Created by Rahul Somasunderam on 6/26/15.
//  Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//


#import "ViewController.h"
#import "TodoService.h"
#import "Todo.h"
#import "TodoCell.h"
#import "ReactiveCocoa.h"


@interface ViewController () {
    TodoService *_todoService;
}

@end

@implementation ViewController

- (TodoService *)todoService {
    if (!_todoService) {
        _todoService = [[TodoService alloc] init];
    }
    return _todoService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    _todoService = nil;
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Count fetched: %i", self.todoService.list.count);
    return self.todoService.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell for index: %i", indexPath.row);
    Todo *todo = self.todoService.list[(NSUInteger) indexPath.row];

    TodoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoCell"];

    RAC(cell.lblText, text) = RACObserve(todo, text);
    RACChannelTo(cell.swcDone, on) = RACChannelTo(todo, done);

    [cell.swcDone.rac_newOnChannel subscribeNext:^(id x) {
        NSLog(@"Data: %@", self.todoService.list);
    }];

    return cell;
}


@end