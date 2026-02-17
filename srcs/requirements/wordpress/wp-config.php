<?php
define('DB_NAME', getenv('MYSQL_DATABASE'));
define('DB_USER', getenv('MYSQL_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('AUTH_KEY',         'ciiRu7fOm/?:-<_Dqm]$_kz,Q]/:t;7gYTu]BRS]phNuv?mRbsyFJH*Ne;n[LmiV');
define('SECURE_AUTH_KEY',  'NQ(e@IAHx?PH%9z4Fr30_:=H`<$4Bc XCe`RL=0#J7)&2K%EtAe)?<|;!E@_ Dqn');
define('LOGGED_IN_KEY',    '+Pq|{{^OR:kC`arPwYwOZ_+DK:HU[dNQ-OA$.C+UgLWZE9K8dr[x4N^.3fx(Uam!');
define('NONCE_KEY',        'OT4umlHjf.%}VGN=Ow+aWBz??Jz(xKeB;P-[$oNrcgc~/u+z1xdCxAmzU).,[CXh');
define('AUTH_SALT',        '(YebmRBBWKX;L>9zI!|/i`|e2kRK#E<z79qWts=lZYCAl=Q_k&WL;GF|61Dclx}E');
define('SECURE_AUTH_SALT', 'ln~v6+pNI8/){^FEe@v!INu^C|k%<m;,1[=5w]Pxc)1sn=GP4^I9K1Fmrn7S+mRS');
define('LOGGED_IN_SALT',   'H|W1F/r<;mR6Jp=vrBv;i0 zvt.^5t09]K&a}(}VB|*rC##-jKCq,DF6Iqm) LA|');
define('NONCE_SALT',       '(C({&|--9fi]rF+ rLMxrjMC2_CCkkeVA742ka>9gDZ?0o+z<FYixoYK{RR9KE/E');

$table_prefix = 'wp_';

define('WP_DEBUG', false);

if ( !defined('ABSPATH') ) {
    define('ABSPATH', __DIR__ . '/');
}
if (
    (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https')
    || (isset($_SERVER['HTTPS']) && ($_SERVER['HTTPS'] === 'on' || $_SERVER['HTTPS'] === 1))
    || (isset($_SERVER['SERVER_PORT']) && $_SERVER['SERVER_PORT'] == 443)
) {
    $_SERVER['HTTPS'] = 'on';
    $_SERVER['SERVER_PORT'] = 443;
}
define('WP_HOME', getenv('WORDPRESS_URL'));
define('WP_SITEURL', getenv('WORDPRESS_URL'));
require_once ABSPATH . 'wp-settings.php';
