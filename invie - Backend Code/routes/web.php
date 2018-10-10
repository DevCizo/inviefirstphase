<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
use App\Eventattendes;
use App\Events;

function dutch_strtotime($datetime) {

    //echo $datetime;die;
    $days = array(
        "Mon"   => "ma",
        "Tue"   => "di",
        "Wed"  => "wo",
        "Thu" => "do",
        "Fri"   => "vr",
        "Sat"  => "za",
        "Su"    => "zo"
    );

    $months = array(
        "January"   => "januari",
        "February"  => "februari",
        "March"    => "maart",
        "April"     => "april",
        "May"       => "mei",
        "June"     => "juni",
        "July"     => "juli",
        "August"   =>"augustus",
        "September" =>  "september",
         "October"  => "oktober" ,
        "November"  => "november" ,
       "December"  =>  "december" 
    );

    $array = explode(" ", $datetime);
   
    $array[0] = $days[$array[0]];
    $array[2] = $months[$array[2]];

    return $array;
}

Route::any('/invite/{id}', function ($id) {
    
    
    $getDetails = Events::select('*')->where('share_id', $id)->first();
    
   
    if(isset($getDetails->share_id)){

        $data['id'] = $getDetails->share_id; 
        $data['message'] = $getDetails->message;
        $data['start_time'] = $getDetails->start_time;
        $data['end_time'] = $getDetails->end_time;
        $data['name'] = $getDetails->name;
        $data['date_time'] = date_create($getDetails->date_time);
        $data['location'] = $getDetails->location;

        setlocale(LC_TIME, 'nl_NL');
        $data['show_time'] = dutch_strtotime(date_format($data['date_time'], "D d F Y"));
        $timestamp = strtotime($getDetails->date_time);
        $data['datetime_display'] = strftime('%a %d %B', $timestamp);

        return view('invite', $data);
    }else{
        return abort(404);
    }
});

Route::any('voteevent', 'EventController@Castvote');

Route::get('/', function () {
    return view('welcome');
});
