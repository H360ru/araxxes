<?php

// Был доработан код от:
// https://github.com/RPicster/Godot-Trello-Reporting-Tool
// и русского поцана
// https://krasin.space/
// https://gist.github.com/Mo45/cb0813cb8a6ebcd6524f6a36d4f8862c

//=======================================================================================================
// Create new webhook in your Discord channel settings and copy&paste URL
//=======================================================================================================

$webhookurl = "https://discord.com/api/webhooks/824232290480947201/4DXxpLQuY9LCAJqkrUxerIqe734HxQF-05tpdFLdeuGjjihbEppGOjhWjN4oM66F-T3m";

//=======================================================================================================
// Compose message. You can use Markdown
// Message Formatting -- https://discordapp.com/developers/docs/reference#message-formatting
//========================================================================================================

//$timestamp = date("c", strtotime("now"));

/*
 * POST values accepted:
 *
 *   name:        The name of the Trello card.
 *   desc:        The Markdown text of the card.
 *   label_id:    An optional label to attach to the card.
 *   cover:       An optional image file to be used as the cover of the card.
 *   attachments: A list of files to attach to the card.
 */
/**
 * Convert a given file upload into a CURLFile for submission with curl_exec()
 *
 * This is basically just a helper to validate the file upload and it stops
 * execution of the script if there are any errors, so the value returned will
 * *always* be valid.
 *
 * @param $file          The file array to handle coming from $_FILES
 * @param $image_only    Whether to only allow images
 * @param $allow_unknown Whether to trust the MIME type provided by uploader
 */
function upload2curl(
    array &$file,
    bool $image_only = false,
    bool $allow_unknown = false
): CURLFile {
    if ($file['error'] !== UPLOAD_ERR_OK) {
        http_response_code(400);
        exit('upload of attachment '.$file['name'].' failed');
    }

    if (!is_uploaded_file($file['tmp_name'])) {
        http_response_code(400);
        exit('refused possible file upload attack for '.$file['name']);
    }

    if ($allow_unknown) {
        $filetype = $file['type'];
    } else {
        $filetype = mime_content_type($file['tmp_name']);
    }

    if ($image_only) {
        switch ($filetype) {
            case 'image/png':  $suffix = 'png'; break;
            case 'image/jpeg': $suffix = 'jpg'; break;
            case 'image/gif':  $suffix = 'gif'; break;
            default:
                http_response_code(403);
                exit('type '.$filetype.' is not allowed for '.$file['name']);
        }
    } else {
        $suffix = pathinfo($file['name'])['extension'] ?? null;
    }

    if ($file['type'] !== $filetype) {
        http_response_code(400);
        exit('wrong type '.$filetype.' for '.$file['name']);
    }

    $name = $file['name'];

    if (!preg_match('/^[a-zA-Z0-9][a-zA-Z0-9_-]*\\.[a-zA-Z0-9]+$/', $name)) {
        $name = uniqid().($suffix !== null ? '.'.$suffix : '');
    }

    return curl_file_create($file['tmp_name'], $file['type'], $name);
}


if (empty($_POST['name']) || empty($_POST['desc'])) {
    http_response_code(400);
    exit('insufficient data');
}

if (!is_string($_POST['name']) || !is_string($_POST['desc'])) {
    http_response_code(400);
    exit('invalid types used in submitted data');
}

$label_id = $_POST['label_id'] ?? null;

if ($label_id !== null && !preg_match('/^[0-9a-fA-F]{24}$/', $label_id)) {
    http_response_code(400);
    exit('invalid label_id');
}

// Обложка для для трелло
//$cover = null;
//if (is_array($_FILES['cover'] ?? null)) {
//    $cover = upload2curl($_FILES['cover'], true);
//}

$attachments = [];

if (is_array($_FILES['attachments'] ?? null)) {
    if (is_array($_FILES['attachments']['name'])) {
        foreach ($_FILES['attachments']['name'] as $index => $name) {
            $file = [
                'name' => $name,
                'type' => $_FILES['attachments']['type'][$index],
                'error' => $_FILES['attachments']['error'][$index],
                'tmp_name' => $_FILES['attachments']['tmp_name'][$index],
            ];

            $attachments[] = upload2curl($file);
        }
    } else {
        $attachments[] = upload2curl($_FILES['attachments']);
    }
}


$json_data = json_encode([
    // Message
    // <@&817553375200673803> - Роль модератора
    "content" => 'Багрепорт от **' . $_POST['player_name']."**\n\n**".$_POST['name']."**\n".$_POST['desc']."\n".'<@&817553375200673803>',//"Hello World! This is message line ;) And here is the mention, use userID <@12341234123412341>",
    
    // Username Менять, когда требуется имя отличное от дефолтного значения в вебхуке
    //"username" => "PHP Сервер",

    // Avatar URL.
    // Uncoment to replace image set in webhook
    //"avatar_url" => "https://ru.gravatar.com/userimage/28503754/1168e2bddca84fec2a63addb348c571d.jpg?size=512",

    // Text-to-speech
    "tts" => false,

    // File upload
    //"file" => $attachments,

    // Embeds Array
    //"embeds" => [
    //    [
            // Embed Title
            //"title" => "PHP - Send message to Discord (embeds) via Webhook",

            // Embed Type
            //"type" => "rich",

            // Embed Description
            //"description" => $_POST['desc'],//"Description will be here, someday, you can mention users here also by calling userID <@12341234123412341>",

            // URL of title link
            //"url" => "https://gist.github.com/Mo45/cb0813cb8a6ebcd6524f6a36d4f8862c",

            // Timestamp of embed must be formatted as ISO8601
            //"timestamp" => $timestamp,

            // Embed left border color in HEX
            //"color" => hexdec( "3366ff" ),

            // Footer
            //"footer" => [
            //    "text" => "GitHub.com/Mo45",
            //    "icon_url" => "https://ru.gravatar.com/userimage/28503754/1168e2bddca84fec2a63addb348c571d.jpg?size=375"
            //],

            // Image to send
            //"image" => [
            //    "url" => "https://ru.gravatar.com/userimage/28503754/1168e2bddca84fec2a63addb348c571d.jpg?size=600"
            //],

            // Thumbnail
            //"thumbnail" => [
            //    "url" => "https://ru.gravatar.com/userimage/28503754/1168e2bddca84fec2a63addb348c571d.jpg?size=400"
            //],

            // Author
            //"author" => [
            //    "name" => "krasin.space",
            //    "url" => "https://krasin.space/"
            //],

            // Additional Fields array
            //"fields" => [
                // Field 1
            //    [
            //        "name" => "Field #1 Name",
            //        "value" => "Field #1 Value",
            //        "inline" => false
            //    ],
                // Field 2
            //    [
            //        "name" => "Field #2 Name",
            //        "value" => "Field #2 Value",
            //        "inline" => true
            //    ]
                // Etc..
            //]
        //]
    //]

], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE );


// Важная фигня, читать ниже
$attachments['payload_json'] = $json_data;

$ch = curl_init( $webhookurl );
// Вот тут самая важная строчка, нигде не было внятного примера с возможностью добавлять свои файлы
// Оказалось https://birdie0.github.io/discord-webhooks-guide/structure/file.html , что там не через json вообще
curl_setopt( $ch, CURLOPT_HTTPHEADER, array('Content-Type: multipart/form-data'));//Content-type: application/json'));
curl_setopt( $ch, CURLOPT_POST, 1);
curl_setopt( $ch, CURLOPT_POSTFIELDS, $attachments);//$json_data);
curl_setopt( $ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt( $ch, CURLOPT_HEADER, 0);
curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1);

$response = curl_exec( $ch );
// If you need to debug, or find out why you can't send message uncomment line below, and execute script.
//echo $response;
curl_close( $ch );