<?php

include_once("functions.inc");

function releaseSql($langs, $config)
{
    $filename = "help.%s.sql";
    try {
        foreach ($langs as $lang) {
            $to = join('/', array("tmp",sprintf($filename, $lang)));
            $file = fopen($to, 'w');
            fwrite($file, createReleaseSql($lang, null, true));
            fclose($file);
        }

        //2. copy over sql files to pingpong source code
        foreach ($langs as $lang) {
            $from = join("/", array("tmp",sprintf($filename, $lang)));
            $to = join("/", array($config['pp_src_dir'],$config['pp_src_sql_dir'],sprintf($filename, $lang)));
            rename($from, $to);
        }
    } catch (Exception $e) {
        echo "Error when creating helptext sql scripts : ",$e->getMessage();
    }
}

//Does an rsync without removing any images
function releaseImages($config)
{
    $from = $config['image_dir']."/";
    $to =join("/", array($config['pp_src_dir'],$config['pp_src_image_dir']));
    error_log("rsync from " . $from . " to " . $to . " from cwd " . getcwd());
    shell_exec("/usr/local/bin/rsync -vzrtpl $from $to");
}


function resetRepo($config)
{
    error_log("./clean-repo.sh");
    return shell_exec("./clean-repo.sh 2>&1");
}


function doCommit($config, $rtNum)
{
    $to =join("/", array($config['pp_src_dir'],$config['pp_src_image_dir']));
    $commitMessage = "Helptext sql and image update,".
    "performed by : ".$_SERVER['REMOTE_USER']." \nreviewed=nobody \nRT-issue:"
    ." #$rtNum";
    $f = fopen("tmp/commit.txt", 'w');
    fwrite($f, $commitMessage);
    fclose($f);
    error_log("./commit-helptexts.sh \"$commitMessage\"");
    return shell_exec("./commit-helptexts.sh -x \"$commitMessage\" 2>&1");
}

$config = parse_ini_file("helptexts.ini");

//we do have support for creating sql for multiple langs att once however we
//are not using it at the moment
$lang = $_REQUEST['lang'];
$langs = array();
$langs[] = $lang;
$langs = array('sv','en');

//TODO validate that this is a number if its not just return an error.
//the javascript also has client side validation so if we get an error here
//its most likely someone trying to bypass the view
if (!is_numeric($_REQUEST['rt'])) {
    echo "error, must specify rt number";
} else {
    $rtNum = intval($_REQUEST['rt']);
    error_log(resetRepo($config));
    releaseSql($langs, $config);
    //We do release all images at once, Too much bookeeping to keep track of
    //what image belongs to what language
    releaseImages($config);
    if (!isDevelopmentMode()||$_SERVER['SERVER_NAME']=='localhost') {  //We dont do a commit in dev environment or when running locally.
        $output = doCommit($config, $rtNum);
        error_log($output);
        echo "ok";
    }
}
