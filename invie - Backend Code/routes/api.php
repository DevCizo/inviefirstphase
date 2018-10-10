<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/
Route::group(['prefix' => 'v1'], function () {
    // Login
    Route::any('login', 'Api\UserController@Login');
    //Register
    Route::any('register', 'Api\UserController@Register');
    Route::any('addevent', 'Api\EventController@Add');
    Route::any('elist', 'Api\EventController@List');
    Route::any('edetail', 'Api\EventController@Detail');
});

