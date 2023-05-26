<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Techer extends Model
{
    use HasFactory;

    //these are fillable input
    protected $fillable = [
        'teach_id',
        'category',
        'patients',
        'experience',
        'bio_data',
        'status',
    ];

    //state this is belong to user table
    public function user(){
        return $this->belongsTo(User::class);
    }
}
