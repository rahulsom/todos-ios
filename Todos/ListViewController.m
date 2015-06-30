//
//  ListViewController.m
//  Todos
//
//  Created by Rahul Somasunderam on 6/26/15.
//  Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//


#import "ListViewController.h"
#import "TodoService.h"
#import "Todo.h"
#import "TodoCell.h"
#import "ReactiveCocoa.h"
#import "ServiceContext.h"


@interface ListViewController ()
@end

@implementation ListViewController

- (TodoService *)todoService {
    return [ServiceContext instance].todoService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnClear.rac_command =
            [[RACCommand
                    alloc]
                    initWithEnabled:[RACSignal return:@YES]
                        signalBlock:^RACSignal *(id input) {
                            [self.todoService clearDone];
                            [self.tblTodos reloadData];
                            return [RACSignal empty];
                        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Count fetched: %lu", (unsigned long)self.todoService.list.count);
    return self.todoService.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell for index: %li", (long)indexPath.row);
    Todo *todo = self.todoService.list[(NSUInteger) indexPath.row];
    TodoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodoCell"];

    RAC(cell.lblText, text) = [RACObserve(todo, text) takeUntil:cell.rac_prepareForReuseSignal];

    RACChannelTerminal *switchTerminal = cell.swcDone.rac_newOnChannel;
    RACChannelTerminal *modelTerminal = RACChannelTo(todo, done, @NO);
    [modelTerminal subscribe:switchTerminal];
    [switchTerminal subscribe:modelTerminal];

    RACSignal *changeSignal = [RACObserve(todo, done) skip:1];

    [changeSignal subscribeNext:^(id x) {
        NSLog(@"Something was toggled");
        [self.todoService save];
    }];

    return cell;
}


@end