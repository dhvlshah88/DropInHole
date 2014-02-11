//
//  Score.m
//  SQL
//
//

#import "Level.h"
#import "AppDelegate.h"

static sqlite3 *database = nil;
static sqlite3_stmt *updateStatement = nil;
static sqlite3_stmt *addStmt = nil;

@implementation Level

@synthesize labelID, levelName, score;

+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; // To refer the application instance, so that we have our data centralised
    
	appDelegate.levelArray = [[NSMutableArray alloc]init]; //set this to null while initializing, because we will load the data every time from the database and will display the updated values in the highscores section
    
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "select * from levelTable";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            //will load the values from database.
            
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Level *levelObj = [[Level alloc] initWithPrimaryKey:primaryKey];
				levelObj.levelName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				//levelObj.score = (NSDecimalNumber *) sqlite3_column_text(selectstmt, 2);
				
                int k = (int)sqlite3_column_int(selectstmt,2);
                levelObj.score = [[NSDecimalNumber alloc] initWithUnsignedInt:k];
				[appDelegate.levelArray addObject:levelObj];
			}
		}
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}

// To finalize the statements
+ (void) finalizeStatements {
	
	if(database) sqlite3_close(database);
	if(updateStatement) sqlite3_finalize(updateStatement);
	if(addStmt) sqlite3_finalize(addStmt);
}

- (id) initWithPrimaryKey:(NSInteger) pk {
	
	self = [super init];
	labelID = pk;
	
	return self;
}



@end
