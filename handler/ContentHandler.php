<?php
class ContentHandler {

    public static function getContent($pageId, $lang, $version) {
        global $db;

        if(isset($version)) {
            $query = "SELECT * FROM content WHERE page_id=? AND lang=? AND version=?";
            $results = $db->getRow($query, array($pageId,$lang,$version));
        } else {
            $query = "SELECT * FROM content WHERE page_id=? AND lang=? ORDER BY version DESC LIMIT 1";
            $results = $db->getRow($query, array($pageId,$lang));
        }

        return $results;
    }


    public static function getAvailableVersions($pageId, $lang) {
        global $db;

        $query = "SELECT version, title, saved, saved_by, published FROM content WHERE page_id=? AND lang=? ORDER BY version";
        $results = $db->getArray($query, array($pageId,$lang));
        return $results;
    }



    /*
    //gets the latest version of a document in all its languages
    public static function getDocument($pageId)
    {
        $query = "select * from content c where page_id = '".$pageId."'"
                ."and version=(select max(version) from content x where x.page_id=c.page_id and x.lang =c.lang) order by lang desc;";
        $res = pg_query($db, $query);

        $results = array();
        while($map = pg_fetch_assoc($res)){
             $results[] = ContentHandler::buildDocument($map);
        }
        return $results;
    }

    //builds adds a couple of fields to the associative array
    public static function buildDocument($doc_map){
       //we need versions, we need to know if they are published or not we also want the date
       $doc_map['availableVersions']= ContentHandler::getVersionInfoForDocument($doc_map['page_id'],$doc_map['lang']);
       $doc_map['edited'] = false;
       $doc_map['firstChange'] = true;
       //$doc_map['breadCrumb'] = PageHandler::createBreadCrumb($doc_map['page_id'],$doc_map['lang']);
       $doc_map['content'] = str_replace("\r\n","\n",$doc_map['content']);
       return $doc_map;
    }

    //gets all documents and all versions for a language
    public static function getVersionInfoForDocument($pageId, $lang){
          $query = sprintf("SELECT * FROM content WHERE page_id='%s' AND lang='%s' order by version",$pageId,$lang);
          $res = pg_query($db, $query);
          $results = array();
          while($map = pg_fetch_assoc($res)){
             $versionInstance = array();
             $versionInstance['version'] = $map['version'];
             $versionInstance['published'] = $map['published'];
             $versionInstance['saved'] = $map['saved'];
             $results[] = $versionInstance;
          }
        return $results;
    }

    public static function getDocumentForLangAndVersion($pageId, $lang=NULL,$version=NULL)
    {
        if($version==NULL){
            $query = sprintf("SELECT * FROM content WHERE page_id='%s' AND lang='%s' AND ".
                    "version=(SELECT max(version) FROM content WHERE page_id='%s' AND lang='%s')"
                    ,$pageId,$lang,$pageId,$lang);
        }
        //TODO REFACTOR
        else{
            $query = sprintf("SELECT * FROM content WHERE page_id='%s' AND lang='%s' AND ".
                    "version='%s'"
                    ,$pageId,$lang,$version);

        }
        $res = pg_query($db, $query);
        $map = pg_fetch_assoc($res);
        return ContentHandler::buildDocument($map);
    }


    
    public static function saveDocument($documentObj, $user)
    {
//        $doPublish = 'false';
//        if ($publish){
//            $doPublish = 'true';
//        }
//        $query = sprintf("UPDATE content set content='%s', title='%s',saved_by='%s',published='%s' WHERE page_id='%s' and lang='%s' and version='%s'",
//                $documentObj->content,$documentObj->title,$user,$doPublish,$documentObj->page_id,$documentObj->lang,$documentObj->version);
//
//        pg_query($db, $query);
          ContentHandler::createDocument($documentObj, $user);
    }


    public static function publishDocument($documentObj, $user)
    {
        //first we save the old object and mark it as published
        //ContentHandler::saveDocument($documentObj,$user,true);
        ContentHandler::createDocument($documentObj, $user);
    }


    public static function createDocument($documentObj, $user){
        $query = sprintf("insert into content (page_id, lang, title, content, version, saved_by, published)"
            ." values ('%s', '%s', '%s', '%s',"
            ." (SELECT COALESCE(max(version),0) FROM content WHERE page_id='%s' AND lang='%s')+1"
            .",'%s','%s')",
            $documentObj->pageId,
            $documentObj->lang,
            pg_escape_string($documentObj->title),
            pg_escape_string($documentObj->content),
            $documentObj->pageId,
            $documentObj->lang,
            $user,
            $documentObj->publish
        );

                //error_log($query);
        pg_query($db, $query);
    }

    public static function addLanguage($lang,$pageId,$user){

            $query = "insert into content (page_id, lang, title, content, version, saved_by)"
     			." values ('$pageId', '$lang', '', '', 1"
     			.", '".$user."')";
     		pg_query($db, $query);
    }

    */


}
