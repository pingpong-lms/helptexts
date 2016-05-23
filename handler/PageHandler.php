<?php


/*
class Tag
{
    public $tagId;
    public $names;

    function __construct() {
        $names = array();
    }
}
*/

class PageHandler {

    /*
    public static function getParents($pageId)
    {
        $query = "WITH RECURSIVE foo(page_id,parent_page_id) AS ".
                "(select pm.page_id,pm.parent_page_id from page pm where page_id='" . $pageId . "' ".
                 "UNION ALL ".
                 "SELECT p.page_id,p.parent_page_id FROM page AS p, foo AS f WHERE p.page_id=f.parent_page_id".
                ")" .
                "SELECT * FROM foo";

        error_log($query);
        $res = pg_query($db, $query);

        return $res;

    }
    */

    public static function getAllPages() {
        global $db;

        $query = "SELECT page.*, content_sv.title AS title_sv, content_en.title AS title_en FROM page ".
            "LEFT JOIN content_latest AS content_sv ON page.page_id=content_sv.page_id AND content_sv.lang='sv' ".
            "LEFT JOIN content_latest AS content_en ON page.page_id=content_en.page_id AND content_en.lang='en' ".
            " WHERE NOT deleted ORDER BY seq_nr";

        $result  = $db->getArray($query);        
        return $result;
    }


    /*
    public static function getPagetitles($pages,$lang){
        $query = "SELECT page_id, title,lang,version from content c where c.page_id in ";
        $queryList = array();
        foreach($pages as $page){
            $queryList[] ="'$page'";
        }
        $query .= "(".join(",",$queryList).")";
        $query .=" AND c.lang = '$lang' AND version =(select max(version) from content x where x.page_id=c.page_id and x.lang=c.lang)";

        $res = pg_query($db, $query);


        $arrLength = count($pages);
        $titles = array_fill(0,$arrLength,"");
        while($elem = pg_fetch_object($res)){
            $index = array_search($elem->page_id,$pages);
            $titles[$index] = $elem->title;
        }

        return $titles;

    }


    public static function getPageTags($pageId, $lang) {
        $tags = array();
        $query = "SELECT DISTINCT tag_id, name FROM page_tags pt JOIN tag_names gn USING (tag_id) WHERE pt.page_id = $1 AND lang = $2";
        $res = pg_query_params($db, $query, array($pageId, $lang));
        while ($row = pg_fetch_object($res)) {
            $tags["{$row->tag_id}"] = $row->name;
        }
        pg_free_result($res);
        return $tags;
    }

    public static function getAllTagNames($lang) {
        $tags = array();
        $query = "SELECT tag_id, name FROM tag_names tn WHERE tn.lang = $1 order by lower(name)";
        $res = pg_query_params($db, $query, array($lang));
        while ($row = pg_fetch_object($res)) {
            $tags["{$row->tag_id}"] = $row->name;
        }
        pg_free_result($res);
        return $tags;
    }

    public static function getAllTags() {
        $tags = array();
        $query = "SELECT tag_id, name, lang FROM tag_names tn order by tag_id, lang, lower(name)";
        $res = pg_query($db, $query);
        $obj = null;
        while ($row = pg_fetch_object($res)) {
            if ($obj == null) {
                $obj = new Tag();
            } else if ($obj->tagId != $row->tag_id) {
                $tags[] = $obj;
                $obj = new Tag();
            }
            $obj->tagId = $row->tag_id;
            $obj->names[$row->lang] = $row->name;
        }
        if ($obj) {
            $tags[] = $obj;
        }
        pg_free_result($res);
        return $tags;
    }

    public static function saveTagName($tagId, $lang, $name) {
        $res = pg_query_params($db, "UPDATE tag_names SET name = $1 WHERE tag_id = $2 AND lang = $3", array($name, $tagId, $lang));
        if (pg_affected_rows($res)) {
            return;
        }
        pg_query_params(db(), "INSERT INTO tag_names (tag_id, lang, name) VALUES ($1, $2, $3)", array($tagId, $lang, $name));
    }

    public static function getTagIdFromName($tagName, $lang) {
        $query = "SELECT tag_id FROM tag_names WHERE lang = $1 AND name = $2";
        $res = pg_query_params($db, $query, array($lang, $tagName));
        if (pg_num_rows($res)) {
            return pg_fetch_object($res)->tag_id;
        }
        // Create tag!
        $res = pg_query($db, "INSERT INTO tags (tag_id) VALUES (default) returning tag_id");
        $tagId = pg_fetch_object($res)->tag_id;
        pg_query_params($db, "INSERT INTO tag_names (tag_id, lang, name) values ($1, $2, $3)", array($tagId, $lang, $tagName));
        return $tagId;
    }

    // tagNames is an array
    public static function savePageTags($pageId, $tagNames, $lang) {
        pg_query($db, "BEGIN");

        // Remove current tags
        $query = "DELETE FROM page_tags WHERE page_id = $1";
        pg_query_params($db, $query, array($pageId));

        // Add new
        $add = "INSERT INTO page_tags (page_id, tag_id) VALUES ($1, $2)";
        foreach (array_unique(array_map('trim', $tagNames)) as &$name) {
            $name = trim($name);
            if (trim($name) == "") continue;
            $tagId = PageHandler::getTagIdFromName($name, $lang);
            pg_query_params($db, $add, array($pageId, $tagId));
        }

        pg_query($db, "COMMIT");
    }

    public static function createBreadCrumb($pageId,$lang){
        $pages = PageHandler::getParents($pageId);
        $arr = array();
        while($page = pg_fetch_object($pages)){
//            error_log($page->page_id);
            array_unshift($arr,$page->page_id);
        }
        foreach($arr as $elem){
            error_log($elem);
        }

        return PageHandler::getPageTitles($arr,$lang);
    }


    public static function createBreadCrumbHTML($pageId, $lang){
        $pages = PageHandler::createBreadCrumb($pageId,$lang);
        return join(" -> ",$pages);
    }
    */


}
