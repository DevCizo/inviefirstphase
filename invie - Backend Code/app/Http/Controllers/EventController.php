<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Events;
use App\Eventattendes;
use Illuminate\Support\Facades\Validator;
use App;
// Event Controller
class EventController extends Controller
{
    // Cast vote
    public function Castvote(Request $request){

        App::setLocale('du');

        $returnData['success'] =  false;
        $returnData['message'] = trans('message.general.GENERAL_ERROR');

        $ip = trim(shell_exec("dig +short myip.opendns.com @resolver1.opendns.com"));
        
        $checkVote  = Eventattendes::select('*')->where('event_id', $request->get('event_id'))->where('ip', $ip)->get();
       
        
        $validator = Validator::make($request->all(), 
        [ 'person_name' => 'required']);

        if ($validator->fails()) {
            return redirect()->back()->with('invalid', trans('message.api.NAME_IS_REQUIRED'));
        }else{
            
            if(isset($checkVote[0]['id'])){
               
              return redirect()->back()->with('erromessage', trans('message.api.ALREADY_VOTED'));
            }else{
    
                $addEventAttendes = new Eventattendes();
                $addEventAttendes->event_id = $request->get('event_id');
                $addEventAttendes->name = $request->get('person_name');
                $addEventAttendes->vote =  $request->get('vote_input');
                $addEventAttendes->ip = $ip;
                $addEventAttendes->status = 1;
                $addEventAttendes->created_at = date('Y-m-d h:i:s');
                $addEventAttendes->save();

                $retutnTrack  = array('message'=> trans('message.api.VOTE_SUBMITED_SUCCESS'), 'is_vote' => $request->get('vote_input'));

                return redirect()->back()->with($retutnTrack);
            }
        }
       // return response()->json($returnData);
       
    }


}
