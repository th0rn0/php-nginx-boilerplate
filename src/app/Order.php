<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{

	protected $table = 'orders';
	protected $primaryKey = 'web_Order_No';

    public function orderLines()
    {
    	return $this->hasMany(OrderLines::class);
    }
}
