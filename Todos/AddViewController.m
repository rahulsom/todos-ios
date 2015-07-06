//
// Created by Rahul Somasunderam on 6/30/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import "ReactiveCocoa.h"
#import "AddViewController.h"
#import "ServiceContext.h"
#import "TodoService.h"

@implementation AddViewController

- (TodoService *)todoService {
    return [ServiceContext instance].todoService;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.btnCancel.rac_command = [[RACCommand
            alloc]
            initWithEnabled:[RACSignal return:@YES]
                signalBlock:^RACSignal *(id input) {
                    [self dismissViewControllerAnimated:NO completion:nil];
                    return [RACSignal empty];
                }];

    self.btnSave.rac_command = [[RACCommand
            alloc]
            initWithEnabled:[RACSignal return:@YES]
                signalBlock:^RACSignal *(id input) {
                    [self.todoService add:self.txtTodo.text];
                    [self dismissViewControllerAnimated:NO completion:nil];
                    return [RACSignal empty];
                }];

}

@end