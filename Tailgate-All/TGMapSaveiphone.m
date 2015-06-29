//
//  TGMapSaveiphone.m
//  Tailgate-All
//
//  Created by Soumarsi Kundu on 27/06/15.
//  Copyright (c) 2015 esolz. All rights reserved.
//

#import "TGMapSaveiphone.h"
#import "UIColor+TGGlobalColor.h"
#import "UIFont+TGGlobalFont.h"
#import "UIImage+TGGlobalImage.h"
#import "NSString+TGGlobalString.h"
@implementation TGMapSaveiphone

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        BackgroundView = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].origin.x, [[UIScreen mainScreen]bounds].origin.y, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
        [BackgroundView setBackgroundColor:[UIColor AlphaBackground]];
        [self addSubview:BackgroundView];
        
        ContentBackView  = [[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].origin.x+5, [[UIScreen mainScreen]bounds].origin.y+90, [[UIScreen mainScreen]bounds].size.width-10, 330)];
        [ContentBackView setBackgroundColor:[UIColor LabelWhiteColor]];
        ContentBackView.layer.cornerRadius = 5.0f;
        [self addSubview:ContentBackView];
        
        FirstLabel = [[UILabel alloc]init];
        [FirstLabel setBackgroundColor:[UIColor ClearColor]];
        [FirstLabel setFont:[UIFont iphonemapsave]];
        [FirstLabel setText:@"You are setup across from"];
        [FirstLabel setTextAlignment:NSTextAlignmentLeft];
        [FirstLabel setTextColor:[UIColor BlackColor]];
        [ContentBackView addSubview:FirstLabel];
        
        SecondLabel = [[UILabel alloc]init];
        [SecondLabel setBackgroundColor:[UIColor ClearColor]];
        [SecondLabel setFont:[UIFont iphonemapsave]];
        [SecondLabel setText:@"in the"];
        [SecondLabel setTextAlignment:NSTextAlignmentLeft];
        [SecondLabel setTextColor:[UIColor BlackColor]];
        [ContentBackView addSubview:SecondLabel];
        
        ThirdLabel = [[UILabel alloc]init];
        [ThirdLabel setBackgroundColor:[UIColor ClearColor]];
        [ThirdLabel setFont:[UIFont iphonemapsave]];
        [ThirdLabel setText:@"yards off of"];
        [ThirdLabel setTextAlignment:NSTextAlignmentLeft];
        [ThirdLabel setTextColor:[UIColor BlackColor]];
        [ContentBackView addSubview:ThirdLabel];
        
        FourthLabel = [[UILabel alloc]init];
        [FourthLabel setBackgroundColor:[UIColor ClearColor]];
        [FourthLabel setFont:[UIFont iphonemapsave]];
        [FourthLabel setText:@"Your tent color is"];
        [FourthLabel setTextAlignment:NSTextAlignmentLeft];
        [FourthLabel setTextColor:[UIColor BlackColor]];
        [ContentBackView addSubview:FourthLabel];
        
        FifthLabel = [[UILabel alloc]init];
        [FifthLabel setBackgroundColor:[UIColor ClearColor]];
        [FifthLabel setFont:[UIFont iphonemapsave]];
        FifthLabel.numberOfLines = 2;
        [FifthLabel setText:@"with a name ID Tag hanging from your tent with your name on it."];
        [FifthLabel setTextAlignment:NSTextAlignmentLeft];
        [FifthLabel setTextColor:[UIColor BlackColor]];
        [ContentBackView addSubview:FifthLabel];

        
        //  ************************* ///////////
        
        //// ********** Button
        
        self.PlacesLabel = [[UIButton alloc]init];
        [self.PlacesLabel setImageEdgeInsets:UIEdgeInsetsMake(0, 235, 0, 0)];
        [self.PlacesLabel setTitleEdgeInsets:UIEdgeInsetsMake(1.0f, -15, 0, 0)];
        [self.PlacesLabel setBackgroundColor:[UIColor MapSaveBackgroundColor]];
        [self.PlacesLabel setTitle:@"Places" forState:UIControlStateNormal];
        self.PlacesLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.PlacesLabel setTitleColor:[UIColor BlackColor] forState:UIControlStateNormal];
        self.PlacesLabel.titleLabel.font = [UIFont iphonemapsave];
        [self.PlacesLabel setImage:[UIImage DropDwonImage] forState:UIControlStateNormal];
        [self.PlacesLabel setImage:[UIImage DropDwonImage] forState:UIControlStateHighlighted];
        [self.PlacesLabel addTarget:_Delegate action:@selector(PlaceButton:) forControlEvents:UIControlEventTouchUpInside];
        [ContentBackView addSubview:self.PlacesLabel];
        
        self.PackegeLabel = [[UIButton alloc]init];
        [self.PackegeLabel setBackgroundColor:[UIColor MapSaveBackgroundColor]];
        [self.PackegeLabel setImageEdgeInsets:UIEdgeInsetsMake(0, 145, 0, 0)];
        [self.PackegeLabel setTitleEdgeInsets:UIEdgeInsetsMake(1.0f, -15, 0, 0)];
        [self.PackegeLabel setTitle:@"Package" forState:UIControlStateNormal];
        self.PackegeLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.PackegeLabel setTitleColor:[UIColor BlackColor] forState:UIControlStateNormal];
        self.PackegeLabel.titleLabel.font = [UIFont iphonemapsave];
        [self.PackegeLabel setImage:[UIImage DropDwonImage] forState:UIControlStateNormal];
        [self.PackegeLabel setImage:[UIImage DropDwonImage] forState:UIControlStateHighlighted];
        [self.PackegeLabel addTarget:_Delegate action:@selector(PackageButton:) forControlEvents:UIControlEventTouchUpInside];
        [ContentBackView addSubview:self.PackegeLabel];
        
        self.DistanceLabel = [[UIButton alloc]init];
        [self.DistanceLabel setBackgroundColor:[UIColor MapSaveBackgroundColor]];
        [self.DistanceLabel setImageEdgeInsets:UIEdgeInsetsMake(0, 155, 0, 0)];
        [self.DistanceLabel setTitleEdgeInsets:UIEdgeInsetsMake(1.0f, -15, 0, 0)];
        [self.DistanceLabel setTitle:@"Distance" forState:UIControlStateNormal];
        self.DistanceLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.DistanceLabel setTitleColor:[UIColor BlackColor] forState:UIControlStateNormal];
        self.DistanceLabel.titleLabel.font = [UIFont iphonemapsave];
        [self.DistanceLabel setImage:[UIImage DropDwonImage] forState:UIControlStateNormal];
        [self.DistanceLabel setImage:[UIImage DropDwonImage] forState:UIControlStateHighlighted];
        [self.DistanceLabel addTarget:_Delegate action:@selector(DistanceButton:) forControlEvents:UIControlEventTouchUpInside];
        [ContentBackView addSubview:self.DistanceLabel];
        
        self.RoadLabel = [[UIButton alloc]init];
        [self.RoadLabel setBackgroundColor:[UIColor MapSaveBackgroundColor]];
        [self.RoadLabel setImageEdgeInsets:UIEdgeInsetsMake(0, 235, 0, 0)];
        [self.RoadLabel setTitleEdgeInsets:UIEdgeInsetsMake(1.0f, -15, 0, 0)];
        [self.RoadLabel setTitle:@"Road" forState:UIControlStateNormal];
        self.RoadLabel.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.RoadLabel setTitleColor:[UIColor BlackColor] forState:UIControlStateNormal];
        self.RoadLabel.titleLabel.font = [UIFont iphonemapsave];
        [self.RoadLabel setImage:[UIImage DropDwonImage] forState:UIControlStateNormal];
        [self.RoadLabel setImage:[UIImage DropDwonImage] forState:UIControlStateHighlighted];
        [self.RoadLabel addTarget:_Delegate action:@selector(RoadButton:) forControlEvents:UIControlEventTouchUpInside];
        [ContentBackView addSubview:self.RoadLabel];
        
        self.ColorLabel = [[UIButton alloc]init];
        [self.ColorLabel setBackgroundColor:[UIColor MapSaveBackgroundColor]];
        [self.ColorLabel setImageEdgeInsets:UIEdgeInsetsMake(0, 105, 0, 0)];
        [self.ColorLabel setTitleEdgeInsets:UIEdgeInsetsMake(1.0f, -15, 0, 0)];
        [self.ColorLabel setTitle:@"Color" forState:UIControlStateNormal];
        self.ColorLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.ColorLabel setTitleColor:[UIColor BlackColor] forState:UIControlStateNormal];
        self.ColorLabel.titleLabel.font = [UIFont iphonemapsave];
        [self.ColorLabel setImage:[UIImage DropDwonImage] forState:UIControlStateNormal];
        [self.ColorLabel setImage:[UIImage DropDwonImage] forState:UIControlStateHighlighted];
        [self.ColorLabel addTarget:_Delegate action:@selector(ColorButton:) forControlEvents:UIControlEventTouchUpInside];
        [ContentBackView addSubview:self.ColorLabel];
        
        
        //       **********/.//////////////////------------
        
        
        FinalSubmitButton = [[UIButton alloc]init];
        [FinalSubmitButton setBackgroundColor:[UIColor ClearColor]];
        [FinalSubmitButton setBackgroundImage:[UIImage DoneImage] forState:UIControlStateNormal];
        [FinalSubmitButton addTarget:_Delegate action:@selector(FinalSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [ContentBackView addSubview:FinalSubmitButton];
        
        FinalCancelButton = [[UIButton alloc]init];
        [FinalCancelButton setBackgroundColor:[UIColor ClearColor]];
        [FinalCancelButton setBackgroundImage:[UIImage CancelImage] forState:UIControlStateNormal];
        [FinalCancelButton addTarget:_Delegate action:@selector(FinalCanCel:) forControlEvents:UIControlEventTouchUpInside];
        [ContentBackView addSubview:FinalCancelButton];
        
        
        if ([[UIScreen mainScreen]bounds].size.width == 320)
        {
            FirstLabel.frame = CGRectMake(5, 10, 210, 30);
            SecondLabel.frame = CGRectMake(ContentBackView.frame.origin.x+5, FirstLabel.frame.origin.y+70, 60, 30);
            ThirdLabel.frame = CGRectMake(ContentBackView.frame.origin.x+200, SecondLabel.frame.origin.y+35, 100, 30);
            FourthLabel.frame = CGRectMake(ContentBackView.frame.origin.x+5, ThirdLabel.frame.origin.y+70, 140, 30);
            FifthLabel.frame = CGRectMake(ContentBackView.frame.origin.x+5, FourthLabel.frame.origin.y+30, 300, 60);
            self.PlacesLabel.frame = CGRectMake([[UIScreen mainScreen]bounds].origin.x+5, FirstLabel.frame.origin.y+35, 260, 30);
            self.PackegeLabel.frame = CGRectMake(SecondLabel.frame.size.width+20, FirstLabel.frame.origin.y+70, 170, 30);
            self.DistanceLabel.frame = CGRectMake(ContentBackView.frame.origin.x+5, SecondLabel.frame.origin.y+35, 180, 30);
            self.RoadLabel.frame = CGRectMake(ContentBackView.frame.origin.x+5, ThirdLabel.frame.origin.y+35, 260, 30);
            self.ColorLabel.frame = CGRectMake(FourthLabel.frame.size.width+20, ThirdLabel.frame.origin.y+70, 130, 30);
            FinalSubmitButton.frame = CGRectMake(ContentBackView.frame.size.width/2-83-7.5f, FourthLabel.frame.origin.y+95, 83.0f, 35);
            FinalCancelButton.frame = CGRectMake(ContentBackView.frame.size.width/2+7.5f, FourthLabel.frame.origin.y+95, 83.0f, 35);
            
        }
        else if ([[UIScreen mainScreen]bounds].size.width == 375)
        {
            FirstLabel.frame = CGRectMake(35, 10, 210, 30);
            SecondLabel.frame = CGRectMake(ContentBackView.frame.origin.x+35, FirstLabel.frame.origin.y+70, 60, 30);
            ThirdLabel.frame = CGRectMake(ContentBackView.frame.origin.x+230, SecondLabel.frame.origin.y+35, 100, 30);
            FourthLabel.frame = CGRectMake(ContentBackView.frame.origin.x+35, ThirdLabel.frame.origin.y+70, 140, 30);
            FifthLabel.frame = CGRectMake(ContentBackView.frame.origin.x+35, FourthLabel.frame.origin.y+30, 300, 60);
            self.PlacesLabel.frame = CGRectMake([[UIScreen mainScreen]bounds].origin.x+35, FirstLabel.frame.origin.y+35, 260, 30);
            self.PackegeLabel.frame = CGRectMake(SecondLabel.frame.size.width+50, FirstLabel.frame.origin.y+70, 170, 30);
            self.DistanceLabel.frame = CGRectMake(ContentBackView.frame.origin.x+35, SecondLabel.frame.origin.y+35, 180, 30);
            self.RoadLabel.frame = CGRectMake(ContentBackView.frame.origin.x+35, ThirdLabel.frame.origin.y+35, 260, 30);
            self.ColorLabel.frame = CGRectMake(FourthLabel.frame.size.width+50, ThirdLabel.frame.origin.y+70, 130, 30);
            FinalSubmitButton.frame = CGRectMake(ContentBackView.frame.size.width/2-83-7.5f, FourthLabel.frame.origin.y+95, 83.0f, 35);
            FinalCancelButton.frame = CGRectMake(ContentBackView.frame.size.width/2+7.5f, FourthLabel.frame.origin.y+95, 83.0f, 35);
        }
        else
        {
            FirstLabel.frame = CGRectMake(50, 10, 210, 30);
            SecondLabel.frame = CGRectMake(ContentBackView.frame.origin.x+50, FirstLabel.frame.origin.y+70, 60, 30);
            ThirdLabel.frame = CGRectMake(ContentBackView.frame.origin.x+245, SecondLabel.frame.origin.y+35, 100, 30);
            FourthLabel.frame = CGRectMake(ContentBackView.frame.origin.x+50, ThirdLabel.frame.origin.y+70, 140, 30);
            FifthLabel.frame = CGRectMake(ContentBackView.frame.origin.x+50, FourthLabel.frame.origin.y+30, 300, 60);
            self.PlacesLabel.frame = CGRectMake([[UIScreen mainScreen]bounds].origin.x+50, FirstLabel.frame.origin.y+35, 260, 30);
            self.PackegeLabel.frame = CGRectMake(SecondLabel.frame.size.width+65, FirstLabel.frame.origin.y+70, 170, 30);
            self.DistanceLabel.frame = CGRectMake(ContentBackView.frame.origin.x+50, SecondLabel.frame.origin.y+35, 180, 30);
            self.RoadLabel.frame = CGRectMake(ContentBackView.frame.origin.x+50, ThirdLabel.frame.origin.y+35, 260, 30);
            self.ColorLabel.frame = CGRectMake(FourthLabel.frame.size.width+65, ThirdLabel.frame.origin.y+70, 130, 30);
            FinalSubmitButton.frame = CGRectMake(ContentBackView.frame.size.width/2-83-7.5f, FourthLabel.frame.origin.y+95, 83.0f, 35);
            FinalCancelButton.frame = CGRectMake(ContentBackView.frame.size.width/2+7.5f, FourthLabel.frame.origin.y+95, 83.0f, 35);

        }
        
        //    ************************* ////

    }
    return self;
}

@end
