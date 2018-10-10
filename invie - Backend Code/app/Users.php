<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Users extends Model
{
    protected $fillable = [
        'name','mo_no', 'status','created_at'
    ];
            
    //Define the table name
    protected $table = 'users';
}
