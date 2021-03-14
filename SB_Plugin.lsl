/*This is the first time we will publicly publish our own smartbots api code */
/* Developed by Kaylie Cloud (2021) 
/* Code is ownered and distrubited by CloudTech
*/

integer link = -91819109; //This is our link channel place holder. We will need a channel to communicate on and ensure do not conflict with other callers.
string sbApiKey = "ba6635110b2fb0f35f925fcadb28b9cd"; //This is our unique api code so smartbots knows this is a legit device with process needs. 
integer limit = 20000; // This is our alicated memory usage (This is required to store data. 

/* This is the core smartbot http function - We will need this to process the Json request. */
smartbotsAPI(string sbBotName, string sbBotAccessCode, string command, list params) {
  list query = [
    "action="  + command,
    "apikey="  + llEscapeURL(sbApiKey),
    "botname=" + llEscapeURL(sbBotName),
    "secret="  + llEscapeURL(sbBotAccessCode)
  ];

  integer i;
  for(i = 0; i<llGetListLength(params); i += 2) {
    query += [ llList2String(params, i) + "=" + llEscapeURL(llList2String(params, i+1)) ];
  }

  string queryString = llDumpList2String(query, "&");
 
  llHTTPRequest("https://api.mysmartbots.com/api/bot.html",
    [HTTP_METHOD,"POST"], queryString);
}

/* This is the Json version (Typically what we will use because it is cleaner to read in the end if we need a reply. */
smartbotsAPIJSON(string sbBotName, string sbBotAccessCode, string command, list params)  {
    smartbotsAPI(sbBotName, sbBotAccessCode, command, params + ["dataType", "json"]);
}

/* Now for the acutal code on how we will use the api */

default{
    on_rez(integer reboot){
        llResetScript();
    }
    changed(integer change){
        if(change & CHANGED_INVENTORY){
            llResetScript();
        }
        if(change & CHANGED_OWNER){
            llResetScript();
        }
    }
    state_entry(){
        llSetMemoryLimit(limit);
        llOwnerSay("\nTotal Memory Used: " + (string)llGetUsedMemory() + " bytes\nTota Memory Free: " + (string)llGetFreeMemory());
    }
    link_message(integer sender, integer chan, string msg, key id){
        if(chan == link){
            /* We have received our call - Lets make the magic happen */
            list data = llParseString2List(msg,["^"],[]);
            string bot = llList2String(data,0);
            string code = llList2String(data,1);
            string call = llList2String(data,2);
            string extra = llList2String(data,3);
            
            /* Now we will apply the new created strings into the api call. */
            smartbotsAPIJSON(bot, code, call, [extra]);
        }
    }
}