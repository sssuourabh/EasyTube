//
//  ETubeSearchViewController.h
//  EasyTube
//
//  Created by Sourabh Shekhar Singh on 20/11/12.
//  Copyright (c) 2012 XCS Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoClass;

@interface ETubeSearchViewController : UITableViewController<UISearchBarDelegate,UIActionSheetDelegate,NSXMLParserDelegate>
{
@private
	NSString        *SearchString;
	NSArray         *SearchResult;
	VideoClass      *SelectedResultItem;
    
	NSURLConnection *SearchConnection;
	NSMutableData   *SearchResultXML;
    
	VideoClass      *CurrentVideoItem;
	NSMutableString *XMLPCDATA;
	NSString        *TitleType;
	NSMutableArray  *SearchResultParsed;
}

@property (nonatomic, strong) NSString        *SearchString;
@property (nonatomic, strong) NSArray         *SearchResult;
@property (nonatomic, strong) VideoClass      *SelectedResultItem;

@property (nonatomic, strong) NSURLConnection *SearchConnection;
@property (nonatomic, strong) NSMutableData   *SearchResultXML;

@property (nonatomic, strong) VideoClass      *CurrentVideoItem;
@property (nonatomic, strong) NSMutableString *XMLPCDATA;
@property (nonatomic, strong) NSString        *TitleType;
@property (nonatomic, strong) NSMutableArray  *SearchResultParsed;

@end
