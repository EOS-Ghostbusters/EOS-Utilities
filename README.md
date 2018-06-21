# EOS-Utilities
EOS Tools and Scripts by the Ghostbusters Team: Blockmatrix, HKEOS, EOSRio, EOS Sw/eden, EOS Tribe, EOS42, and eosDAC

#### restarter.pl - Perl script for monitoring/restarting EOS node and sending SMS alerts oon restart and fail.
##### Install as a cronjob on your system as often as you would like.
##### Before you could use the script:

##### 1. Install Perl if not installed

##### 2. Install Perl packages:

sudo cpan install String/CamelCase.pm

sudo cpan install Log::Log4perl

sudo cpan install JSON

sudo cpan install REST::Client

##### 3. Install TextMagic: https://github.com/textmagic/textmagic-rest-perl

##### 4. Get account with TestMagic API: https://www.textmagic.com/docs/api/

NOTE: If restart fails - a flag file RESTART_FAILED is created and script stops running until file is removed.

#### claim.pl - script to claim rewards after 24h period. Designed to run as cronjob every minute.

#### checkPayment.sh - Check producer payments.

#### vanity.sh - Find EOS key with certain short name in it by brute force

#### send-telegram.sh - Send messages to Telegram
