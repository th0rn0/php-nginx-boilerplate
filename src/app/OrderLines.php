<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class OrderLines extends Model
{
	
	protected $table = 'orders_lines';
    protected $primaryKey = 'web_Order_Line_No';

    public function order()
    {
    	return $this->belongsTo(Order::class);
    }
}
