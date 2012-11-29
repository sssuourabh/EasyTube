//
//  ETubeSearchViewController.m
//  EasyTube
//
//  Created by Sourabh Shekhar Singh on 20/11/12.
//  Copyright (c) 2012 XCS Technologies. All rights reserved.
//

#import "ETubeSearchViewController.h"
#import <CFNetwork/CFNetwork.h>
#import "ETubeCustomCell.h"
#import "VideoClass.h"
#import "VideoDBClass.h"


@interface ETubeSearchViewController ()

@end

@implementation ETubeSearchViewController

@synthesize SearchString;
@synthesize SearchResult;
@synthesize SelectedResultItem;
@synthesize SearchConnection;
@synthesize SearchResultXML;
@synthesize CurrentVideoItem;
@synthesize XMLPCDATA;
@synthesize TitleType;
@synthesize SearchResultParsed;


static NSUInteger ACTION_DOWNLOAD = 0;
static NSUInteger ACTION_CANCEL   = 1;

#pragma mark Utility methods

- (void)handleError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
	[alert show];
}

#pragma mark NSNibAwaking methods

- (void)awakeFromNib {
	self.SearchString       = nil;
	self.SearchResult       = nil;
	self.SelectedResultItem = nil;
	self.SearchConnection   = nil;
	self.SearchResultXML    = nil;
	self.CurrentVideoItem   = nil;
	self.XMLPCDATA          = nil;
	self.TitleType          = nil;
	self.SearchResultParsed = nil;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.SearchResult != nil) {
		return [self.SearchResult count];
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchViewCellId";
    ETubeCustomCell *tempCustomCell=[[ETubeCustomCell alloc] init];
    tempCustomCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    VideoClass *item = [self.SearchResult objectAtIndex:indexPath.row];
    //ETubeVideoInfoClass *objEtubeInfo=(ETubeVideoInfoClass *)[self.SearchResult objectAtIndex:indexPath.row];
    
	tempCustomCell.imageAtCell.image = [item resizeThumbnailToSize:CGSizeMake(100  ,90)];
	tempCustomCell.titleAtCell.text      = item.Title;
	tempCustomCell.lengthAtCell.text     = [item lengthToString];
	tempCustomCell.authorAtCell.text     = item.Author;
    
    return tempCustomCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.SelectedResultItem = [[VideoClass alloc] initWithVideo:[self.SearchResult objectAtIndex:indexPath.row]];
    
	UIActionSheet *action_sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
	[action_sheet addButtonWithTitle:NSLocalizedString(@"Download", @"Download")];
	[action_sheet addButtonWithTitle:NSLocalizedString(@"Cancel",   @"Cancel")];
    
	action_sheet.cancelButtonIndex = ACTION_CANCEL;
    
	[action_sheet showInView:self.view];
}

#pragma mark UISearchBarDelegate methods

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
    
	if (self.SearchString != nil) {
		searchBar.text = [NSString stringWithString:self.SearchString];
	} else {
		searchBar.text = nil;
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
    
	if (self.SearchConnection == nil && searchBar.text != nil && ![searchBar.text isEqualToString:@""]) {
		self.SearchString = [NSString stringWithString:searchBar.text];
        
		NSString     *search_url     = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?vq=%@&orderby=relevance&start-index=1&max-results=25&alt=atom", [self.SearchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSURLRequest *search_request = [NSURLRequest requestWithURL:[NSURL URLWithString:search_url]];
        
		self.SearchConnection = [[NSURLConnection alloc] initWithRequest:search_request delegate:self];
        
		if (self.SearchConnection == nil) {
			NSDictionary *user_info = [NSDictionary dictionaryWithObject:NSLocalizedString(@"Connection failed", @"Connection failed") forKey:NSLocalizedDescriptionKey];
			NSError      *error     = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorUnknown userInfo:user_info];
            
			[self handleError:error];
		} else {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadTubeAppDelegate NetworkActivityStarted" object:nil];
		}
	} else {
		if (self.SearchString != nil) {
			searchBar.text = [NSString stringWithString:self.SearchString];
		} else {
			searchBar.text = nil;
		}
	}
}

#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == ACTION_DOWNLOAD) {
		VideoDBClass *video_db = [[VideoDBClass alloc] init];
        
		if ([video_db isVideoExists:self.SelectedResultItem]) {
			NSDictionary *user_info = [NSDictionary dictionaryWithObject:NSLocalizedString(@"This video is already loaded or queued", @"This video is already loaded or queued") forKey:NSLocalizedDescriptionKey];
			NSError      *error     = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorUnknown userInfo:user_info];
            
			[self handleError:error];
		} else {
			NSError *error;
            
			if ([video_db createDownload:self.SelectedResultItem error:&error]) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadViewController DownloadAdded" object:nil];
			} else {
				[self handleError:error];
			}
		}
	}
    
	self.SelectedResultItem = nil;
	
}

#pragma mark NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.SearchResultXML = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.SearchResultXML appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadTubeAppDelegate NetworkActivityEnded" object:nil];
    
	[self handleError:error];
    
	self.SearchConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[NSThread detachNewThreadSelector:@selector(parseSearchData:) toTarget:self withObject:[NSData dataWithData:self.SearchResultXML]];
}

- (void)parseSearchData:(NSData *)data {
	@autoreleasepool {
        
		self.SearchResultParsed = [NSMutableArray array];
        
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        
		[parser setDelegate:self];
		[parser parse];
        
		self.CurrentVideoItem = nil;
		self.XMLPCDATA        = nil;
		self.TitleType        = nil;
        
		[self performSelectorOnMainThread:@selector(parseCompleted:) withObject:nil waitUntilDone:NO];
        
	}
}

- (void)parseCompleted:(NSObject *)object {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadTubeAppDelegate NetworkActivityEnded" object:nil];
    
	self.SearchResult = [NSArray arrayWithArray:self.SearchResultParsed];
    
	[self.tableView reloadData];
    
	self.SearchConnection = nil;
}

#pragma mark NSXMLParser methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	self.XMLPCDATA = [NSMutableString stringWithString:@""];
	
	if ([elementName isEqualToString:@"entry"]) {
		self.CurrentVideoItem = [[VideoClass alloc] init];
	} else if ([elementName isEqualToString:@"title"]) {
		if ([attributeDict valueForKey:@"type"] != nil) {
			self.TitleType = [NSString stringWithString:[attributeDict valueForKey:@"type"]];
		} else {
			self.TitleType = @"";
		}
	} else if ([elementName isEqualToString:@"media:player"]) {
		if ([attributeDict valueForKey:@"url"] != nil) {
			self.CurrentVideoItem.URL = [NSString stringWithString:[attributeDict valueForKey:@"url"]];
		}
	} else if ([elementName isEqualToString:@"media:thumbnail"]) {
		if ([attributeDict valueForKey:@"url"] != nil) {
			if (self.CurrentVideoItem.Thumbnail == nil) {
				self.CurrentVideoItem.Thumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[attributeDict valueForKey:@"url"]]]];
			}
		}
	} else if ([elementName isEqualToString:@"yt:duration"]) {
		if ([attributeDict valueForKey:@"seconds"] != nil) {
			self.CurrentVideoItem.Length = [[attributeDict valueForKey:@"seconds"] intValue];
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"entry"]) {
		if (self.CurrentVideoItem != nil && [self.CurrentVideoItem isValid]) {
			[self.SearchResultParsed addObject:self.CurrentVideoItem];
		}
        
		self.CurrentVideoItem = nil;
	} else if ([elementName isEqualToString:@"title"]) {
		if (self.XMLPCDATA != nil && self.TitleType != nil && [self.TitleType isEqualToString:@"text"]) {
			self.CurrentVideoItem.Title = [NSString stringWithString:self.XMLPCDATA];
		}
        
		self.TitleType = nil;
	} else if ([elementName isEqualToString:@"name"]) {
		if (self.XMLPCDATA != nil) {
			self.CurrentVideoItem.Author = [NSString stringWithString:self.XMLPCDATA];
		}
	}
    
	self.XMLPCDATA = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (self.XMLPCDATA != nil) {
		[self.XMLPCDATA appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	[self performSelectorOnMainThread:@selector(handleError:) withObject:parseError waitUntilDone:NO];
}


@end
