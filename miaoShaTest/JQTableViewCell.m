//
//  JQTableViewCell.m
//  openglStudy
//
//  Created by Monstar on 2017/9/4.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "JQTableViewCell.h"

@implementation JQTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
+ (JQTableViewCell *)initWith:(UITableView *)tableView{
    static NSString *ID = @"CELL";
    JQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"JQTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

@end
