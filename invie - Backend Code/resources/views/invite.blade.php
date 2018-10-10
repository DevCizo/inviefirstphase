<!DOCTYPE html>
<html lang="en">
<head>
  <title>Invie: De makkelijkste manier om je event te organiseren</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <base href="<?= url('/') . '/' ?>">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,600" rel="stylesheet" type="text/css">

    <meta property="og:description" content="Invie: De makkelijkste manier om je event te organiseren">
    <meta property="og:image" content="<?= url('/') ?>/public/images/invie-invite.jpg">

    <style>

       
        body, html {
            height: 100%;
            margin: 0;
            font: 400 15px/1.8 "Lato", sans-serif;
            color: #ffff;
        }

        .bgimg-1 {
            background-image: url("./public/images/invie-bg.jpeg");
            height: 100%;
            -webkit-background-size: cover;
            -moz-background-siz e: cover;
            -o-background-size: cover;
            background-size: cover;
            position: relative;
            background-repeat: no-repeat;
            background-size: cover;
            background-size: 100% 100%;
        }

        .caption {
            position: absolute;
            left: 0;
            width: 100%;
            text-align: center;
            color: #FFFFF;
        }

        .caption span.border {
            color: #ffff;
            padding: 18px;
            font-size: 25px;
            letter-spacing: 10px;
        }

        h1 {
            letter-spacing: 5px;
            text-transform: uppercase;
            font: "Lato", sans-serif;
            color: #ffff;
        }
        p{
            font: "Lato", sans-serif;
            color: #ffff;
            width: 50%;
            margin: auto;
            margin-bottom: 10px;
        }
        .addeventatc{
            margin-top: 5px;
        }
        .margin-center{    margin-top: 200px;}

        @media only screen and (max-width: 600px) {
            .margin-center{ margin-top: 100px;}
        }
        @media (min-width: 481px) and (max-width: 767px) {
            .margin-center{ margin-top: 80px;}
        }

    </style>
</head>
<body>
    <!-- <div class="bgimg-1"> -->
    <div class="caption bgimg-1">
        <div class="margin-center">
        <h1>Invie</h1>
        <div class="row">
        <p><strong>Datum: </strong>{{$show_time[0]}} {{$show_time[1]}} {{$show_time[2]}} <strong>Tijd: </strong>{{date ('H:i',strtotime($start_time))}}</p>
        <p><strong>Locatie: </strong>{{$location}}</p>
        </div>
        
        @if(!session()->has('message'))
        <div class="col-md-12 col-sm-12 col-xs-12">
            <p>{{$message}}</p>
        </div>
        @endif
        <div class="col-md-12 col-sm-12 col-xs-12">
                
                @if(session()->has('message'))
                    <!-- <p class="alert alert-success alert-dismissible">
                     <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                        {{ session()->get('message') }}
                    </p> -->
                    @if(session()->has('is_vote') && session()->get('is_vote') == 1)
                        <!-- Button code -->
                        <div title="Add to Calendar" class="addeventatc">
                                Toevoegen aan kalender
                                <span class="start"><?=date_format($date_time, 'Y:m:d')?> <?=$start_time?></span>
                                <span class="end"><?=date_format($date_time, 'Y:m:d')?> <?=$end_time?></span>
                                <span class="timezone">Europe/Andorra</span>
                                <span class="title"><?=$name?></span>
                                <span class="description"><?=$message?></span>
                                <!-- <span class="organizer">{{$name}}</span> -->
                                <span class="location">{{$location}}</span>
                        </div>
                    @endif
                @endif
                @if(session()->has('erromessage'))
                    <!-- <p class="alert alert-warning alert-dismissible">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                        {{ session()->get('erromessage') }}
                    </p> -->
                @endif
                @if(session()->has('invalid'))
                    <p class="alert alert-danger alert-dismissible">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                        {{ session()->get('invalid') }}
                    </p>
                @endif
                @if(!session()->has('message'))
                <form method="post" id="vote_form" class="form-inline" action="voteevent">
                @csrf
                <input type="hidden" name="event_id" value="{{$id}}">
                <input type="hidden" name="vote_input" id="vote_input" value="0">
                <div class="form-group col-md-12 col-sm-12 col-xs-12">
                    <input type="text" class="form-control" id="name" name="person_name" placeholder="Uw naam" style="color: black;font-size: 20px;" required>
                </div>
                <br>
                <br>
                <div class="form-group col-md-12 col-sm-12 col-xs-12" style="text-align:center">
                    <button type="submit" class="btn btn-success button-vote" data-id="1">Ja, ik kom!</button>
                    <button type="submit" class="btn btn-default button-vote" data-id="2">Nee, ik kan niet</button>
                </div>
                </form>
                @endif
            </div>
            
        </div>
        </div>
    </div>
    <script type="text/javascript" src="https://addevent.com/libs/atc/1.6.1/atc.min.js" async defer></script>
    <script src="public/js/script.js" type="text/javascript"></script>
</body>
</html>
