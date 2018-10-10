<?php

namespace App\Http\Controllers\Api;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Response;
use App\Events;
use App\Eventattendes;
use DB;
use Crypt;
use Illuminate\Support\Facades\Validator;
use App;
// Event Controller
class EventController extends Controller
{   

    // Create add
    public function Add(Request $request){

        $returnData['success'] =  false;
        $returnData['message'] = trans('message.general.GENERAL_ERROR');
        App::setLocale('du');
        $postData = $request->all();

        if(isset($postData) && count($postData) > 0){
            
            $validator = Validator::make($request->all(), 
            [
                'name' => 'required',
                'datetime' => 'required',
                'message' => 'required',
                'start_time' => 'required',
                'end_time' => 'required',
                'locaton' => 'location',
                'event_type' => 'required',
                'user_id' => 'required'
            ]);
    
            if ($validator->fails()) {
                $returnData['success'] = false;
                $returnData['message'] = $validator->messages()->first();
            }else{

                $shareId = time();
                $createNewEvent = new Events();
                $createNewEvent->name = $request->get('name');
                $createNewEvent->date_time = $request->get('datetime');
                $createNewEvent->start_time = $request->get('start_time');
                $createNewEvent->end_time = $request->get('end_time');
                $createNewEvent->message = $request->get('message');
                $createNewEvent->share_id = $shareId;
                $createNewEvent->location = $request->get('location');
                $createNewEvent->event_type = $request->get('event_type');
                $createNewEvent->user_id = $request->get('user_id');
                $createNewEvent->status = 1;
                $createNewEvent->created_at = date('Y-m-d h:i:s');
                $createNewEvent->save();

                $returnData['success'] = true;
                
                $returnData['url'] = url('').'/invite/'.$shareId;
                $returnData['message'] = trans('message.api.EVENT_IS_CREATED');
            }
        }else{
            $returnData['success'] = true;
            $returnData['message'] = trans('message.general.INVALID_PARAMS');
        }

        return response()->json($returnData);
    }

    // List events
    public function List(Request $request){

        $returnData['success'] =  false;
        $returnData['message'] = trans('message.general.GENERAL_ERROR');
        App::setLocale('du');
        $postData = $request->all();

        if(isset($postData) && count($postData) > 0){
            
            $validator = Validator::make($request->all(), 
            [
                'user_id' => 'required',
                'page' => 'required',
                'page_size' => 'required'
            ]);
    
            if ($validator->fails()) {
                $returnData['success'] = false;
                $returnData['message'] = $validator->messages()->first();
            }else{
                
                $limit = $postData['page_size'];
                $offset = 0;
                if($postData['page'] != 0){
                    $offset = $limit * $postData['page'];
                }

                // Event list
                $getEventList = Events::select('events.*',
                                    DB::raw('(select count(id) from event_attendees where event_id = events.share_id and vote = 1) as going'), 
                                    DB::raw('(select count(id) from event_attendees where event_id = events.share_id and vote = 2) as not_going'))
                                    ->where('events.user_id', $request->get('user_id'))
                                    ->Where(function ($query) use ($postData) {
                                        if (isset($postData['search']) && $postData['search'] != ''):
                                            $query->where('events.name', 'like', '%' . $postData['search'] . '%');
                                        endif;
                                    })
                                    ->offset($offset)
                                    ->limit($limit)
                                    ->orderby('events.id', 'desc')
                                    ->get();
                
                $getEventList = json_decode(json_encode($getEventList), true);

                if($getEventList){

                    $returnData['success'] = true;
                    $returnData['data'] = $getEventList;
                    $returnData['message'] = trans('message.general.GENERAL_SUCCESS');
                }else{
                    $returnData['success'] = true;
                    $returnData['data'] = array();
                    $returnData['message'] = $offset == 0 ? trans('message.api.NO_EVENTS') : trans('message.api.NO_MORE_EVENTS_FOUND') ;
                }
            }
        }else{

            $returnData['success'] = true;
            $returnData['message'] = trans('message.general.INVALID_PARAMS');
        }

        return response()->json($returnData);
    }

    // To get info for event
    public function Detail(Request $request){

        $returnData['success'] = false;
        $postData = $request->all();
        App::setLocale('du');

        // Check if params is available
        if(isset($postData) && count($postData) > 0){
        
            // Validator reader
            $validator = Validator::make($request->all(), ['event_id' => 'required']);
            
            if ($validator->fails()) {
                $returnData['success'] = false;
                $returnData['message'] = $validator->messages()->first();
            }else{

                $getEventInfo = Events::select('events.*',
                            DB::raw('(select count(id) from event_attendees where event_id = events.share_id and vote = 1) as going'), 
                            DB::raw('(select count(id) from event_attendees where event_id = events.share_id and vote = 2) as not_going'))
                            ->where('events.id', $request->get('event_id'))
                            ->first();
                
                if($getEventInfo){

                    $returnData['data'] = $getEventInfo;
                    $returnData['data']['share_url'] = url('').'/invite/'.$getEventInfo->share_id;
                    $getAttendeesList = Eventattendes::select('*')->where('event_id', $getEventInfo->share_id)->get();
                    $getAttendeesList = json_decode(json_encode($getAttendeesList), true);

                    if($getAttendeesList){
                        $returnData['data']['list'] = $getAttendeesList;
                        $returnData['data']['list_message'] = trans('message.general.GENERAL_SUCCESS');
                    }else{
                        $returnData['data']['list'] = array(); 
                        $returnData['data']['list_message'] = trans('message.api.NO_ATTENDEES_YET');
                    }
                    
                    $returnData['success']  = true;
                }
            }    
         }else{
            $returnData['success'] = false;
            $returnData['message'] = trans('message.general.INVALID_PARAMS');
        }
        
        return response()->json($returnData);
    }


}
