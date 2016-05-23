<?php

include_once('api-init.php');
include_once('../handler/PageHandler.php');





if ($_SERVER['REQUEST_METHOD'] != ('GET' || 'POST')) {
    $errors[] = "Request method not supported";
    
} else if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $pageId = $_GET['pageId'];
    if($pageId == NULL){
        $allPages = PageHandler::getAllPages();
        
        $pages = array();
        foreach ($allPages as $page) {
            $pageId = $page['page_id'];
            $parentId = $page['parent_page_id'];
            if(empty($parentId)) $parentId = "root";

            if(!isset($pages[$pageId])) $pages[$pageId] = array();
            $pages[$pageId]['titleSV'] = $page['title_sv'];
            $pages[$pageId]['titleEN'] = $page['title_en'];
            $pages[$pageId]['isFolder'] = $page['is_folder']==="t";
            $pages[$pageId]['underDevelopment'] = $page['under_development']==="t";
            $pages[$pageId]['giverprop'] = $page['giver_prop'];
            $pages[$pageId]['parentPageId'] = $page['parent_page_id'];
            
            $pages[$pageId]['studentTopic'] = $page['student_topic']==="t";
            $pages[$pageId]['teacherTopic'] = $page['teacher_topic']==="t";
            $pages[$pageId]['adminTopic'] = $page['admin_topic']==="t";
            
            if(!isset($pages[$parentId])) $pages[$parentId] = array();
            if(!isset($pages[$parentId]['children'])) $pages[$parentId]['children'] = array();

            $pages[$parentId]['children'][] = $pageId;
        }
        $response['pages'] = $pages;
        http_response_code(200);
    } else{
        $errors[] = "get single page not implemented";
    }
} else if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $pageId = $_POST['pageId'];
    $newPageId = $_POST['newPageId'];
    
    $isFolder = isset($_POST["isFolder"]);
    $parentPageId = $_POST["parentPageId"];
    $studentTopic = isset($_POST["studentTopic"]);
    $teacherTopic = isset($_POST["teacherTopic"]);
    $adminTopic = isset($_POST["adminTopic"]);
    $underDevelopment = isset($_POST["underDevelopment"]);
    $giverProp = $_POST["giverProp"];
    


    if(empty($pageId)) {
        if(empty($newPageId)) {
            $errors[] = "Du måste ange ett nytt unikt sid id!";
        } else {
            $pageId = $newPageId;
            
            // Check that id is unique
            $query = "select 1 from page where page_id = '$pageId'";
            $res = pg_query(db(), $query);
            if (pg_num_rows($res) != 0) {
                $errors[] = "Du måste ange ett unikt id! '$pageId' används redan.";

            } else {
                $query = "select max(seq_nr) + 1 from page where parent_page_id ";
                if (strlen($parentPageId) == 0) {
                    $query .= " is null";
                } else {
                    $query .= " = '$parentPageId'";
                }
                $seqNr = pg_fetch_result(pg_query(db(), $query), 0, 0);
                if (!is_numeric($seqNr)) {
                  $seqNr = 1;
                }

                $query = "insert into page (page_id, parent_page_id, is_folder, seq_nr, student_topic, teacher_topic, admin_topic, under_development, is_manual, giver_prop)"
                    ." values ('$pageId'"
                    .", ".(strlen($parentPageId) == 0 ? "null" : "'$parentPageId'")
                    .", ".($isFolder ? "true" : "false")
                    .", $seqNr"
                    .", ".($studentTopic ? "true" : "false")
                    .", ".($teacherTopic ? "true" : "false")
                    .", ".($adminTopic ? "true" : "false")
                    .", ".($underDevelopment ? "true" : "false")
                    .", ".($isManual ? "true" : "false")
                    .", '$giverProp'"
                    .")";
                pg_query(db(), $query);
                $response['pageId'] = $pageId;
                http_response_code(201);
            }
        }
        
    } else {
        
        // Check that id is unique
        if ($pageId != $newPageId) {
            $query = "select 1 from page where page_id = '$newPageId'";
            $res = pg_query(db(), $query);
            if (pg_num_rows($res) != 0) {
                $errors[] = "Du måste ange ett unikt id! '$newPageId' används redan.";
            }
        }

        if (empty($errors)) {
            $query = "update page set page_id = '$newPageId'"
                .", parent_page_id = ".(empty($parentPageId) ? "null" : "'$parentPageId'")
                .", student_topic = ".($studentTopic ? "true" : "false")
                .", teacher_topic = ".($teacherTopic ? "true" : "false")
                .", admin_topic = ".($adminTopic ? "true" : "false")
                .", under_development = ".($underDevelopment ? "true" : "false")
                .", is_manual = ".($isManual ? "true" : "false")
                .", is_folder = ".($isFolder ? "true" : "false")
                .", giver_prop = '$giverProp'"
                ." where page_id = '$pageId'";
            pg_query(db(), $query);
            
            //PageHandler::savePageTags($pageId, $tagsNames, 'sv');
            
            /*
            if ($origParentPageId != $parentPageId) {
                $query = "select max(seq_nr) + 1 from page"
                    ." where parent_page_id"
                    .(strlen($parentPageId) == 0 ? " is null" : " = '$parentPageId'");
                $seqNr = pg_fetch_result(pg_query(db(), $query), 0, 0);
                if (!is_numeric($seqNr)) {
                    $seqNr = 1;
                }
                $query = "update page set seq_nr = $seqNr"
                    ." where page_id = '$pageId'";
                pg_query(db(), $query);
            }
            */

            $response['pageId'] = $newPageId; 
            http_response_code(200);
        }
    }

       
}

require "api-finish.php";