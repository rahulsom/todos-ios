//
// Created by Rahul Somasunderam on 6/27/15.
// Copyright (c) 2015 Rahul Somasunderam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Todo;

@interface TodoCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UISwitch *swcDone;

@end