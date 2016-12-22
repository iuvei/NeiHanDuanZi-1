//
//  BottomTableViewCell.m
//  
//
//  Created by fuyuzheng on 2016/11/23.
//
//

#import "BottomTableViewCell.h"

@implementation BottomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}
- (IBAction)click:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"zan" object:self];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
