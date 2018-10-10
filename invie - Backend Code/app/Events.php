<?php

namespace App;
use Illuminate\Database\Eloquent\Model;

class Events extends Model
{
    protected $fillable = [
        'user_id','name', 'date_time', 'event_type', 'message', 'status','created_at','updated_at'
    ];
            
    //Define the table name
    protected $table = 'events';
}
