//
//  FNAllGoodsSubCell.m
//  ERoadDemo
//
//  Created by Admin on 2021/4/21.
//

#import "FNAllGoodsSubCell.h"

@interface FNAllGoodsSubCell ()

@property (nonatomic, weak) UIView *redLineView;

@end


@implementation FNAllGoodsSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.bgColor(BGCOlOLSTR);
    self.contentView.bgColor(BGCOlOLSTR);
    
    UIView *redLineView = View.bgColor(@"red").fixWidth(2).addTo(self.contentView).makeCons(^{
        make.left.top.bottom.equal.superview.constants(0);
    });
    
    self.redLineView = redLineView;
    redLineView.hidden = YES;
    
    View.bgColor(@"white").addTo(self.contentView).makeCons(^{
        make.left.bottom.right.equal.superview.constants(0);
        make.height.equal.constants(0.5);
    });
    
    self.textLabel.lines(0);
    self.textLabel.font = [UIFont systemFontOfSize:16];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.redLineView.hidden = !selected;
    self.contentView.bgColor(selected ? @"white":BGCOlOLSTR);
    self.textLabel.textColor = selected ? Color(SELECTEDCOLORSTR) : Color(GRAYTEXTCOLORSTR);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
