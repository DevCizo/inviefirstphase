<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Eventattendes extends Model
{
    protected $fillable = [
        'event_id','name', 'vote', 'ip', 'status','created_at','updated_at'
    ];
            
    //Define the table name
    protected $table = 'event_attendees';
}
