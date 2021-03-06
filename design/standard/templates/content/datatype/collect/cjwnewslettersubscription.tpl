{* DO NOT EDIT THIS FILE! Use an override template instead.

content/datatype/collect/cjwnewslettersubscription.tpl
*}

{def $attribute_base = 'ContentObjectAttribute'
     $attribute_content = $attribute.content
     $newsletter_user = $attribute_content.existing_newsletter_user
     $subscription_array = array()}

{if is_object( $newsletter_user ) }
    {set $subscription_array = $newsletter_user.subscription_array}
{/if}


    {def $newsletter_root_node_id = ezini( 'NewsletterSettings', 'RootFolderNodeId', 'cjw_newsletter.ini' )
         $available_output_formats = 2} {* for html tables *}


    {def $newsletter_system_node_list = fetch( 'content', 'tree', hash('parent_node_id', $newsletter_root_node_id,
                                                            'class_filter_type', 'include',
                                                            'class_filter_array', array('cjw_newsletter_system'),
                                                            'sort_by', array( 'name', true() ),
                                                            'limitation', hash( ) )) }

    {if $newsletter_system_node_list|count|eq(0)}
        <p>
            {'No newsletters available.'|i18n( 'cjw_newsletter/datatype/cjwnewslettersubscription' )}
        </p>
    {else}

        {def $newsletter_list_node_list = fetch( 'content', 'tree', hash('parent_node_id', $newsletter_system_node_list.0.node_id,
                                                                'extended_attribute_filter',
                                                                      hash( 'id', 'CjwNewsletterListFilter',
                                                                            'params', hash( 'siteaccess', array( 'current_siteaccess' ) ) ),
                                                                'class_filter_type', 'include',
                                                                'class_filter_array', array('cjw_newsletter_list'),
                                                                'limitation', hash() ))
             $newsletter_available=false()
        }

        {foreach $newsletter_system_node_list as $system_node}
            {set $newsletter_list_node_list = fetch( 'content', 'tree', hash('parent_node_id', $system_node.node_id,
                                                                'extended_attribute_filter',
                                                                      hash( 'id', 'CjwNewsletterListFilter',
                                                                            'params', hash( 'siteaccess', array( 'current_siteaccess' ) ) ),
                                                                'class_filter_type', 'include',
                                                                'class_filter_array', array('cjw_newsletter_list'),
                                                                'limitation', hash( ) )) }
            {if $newsletter_list_node_list|count()|gt(0)}
                {set $newsletter_available=true()}
            {/if}
        {/foreach}
        {undef $newsletter_list_node_list}

        {if $newsletter_available|not()}
            <p>
                {'No newsletters available.'|i18n( 'cjw_newsletter/datatype/cjwnewslettersubscription' )}
            </p>

        {else}

                {foreach $newsletter_system_node_list as $system_node}
                    {def $newsletter_list_node_list = fetch( 'content', 'tree',
                                                                hash('parent_node_id', $system_node.node_id,
                                                                     'extended_attribute_filter',
                                                                          hash( 'id', 'CjwNewsletterListFilter',
                                                                                'params', hash( 'siteaccess', array( 'current_siteaccess' ) ) ),
                                                                     'class_filter_type', 'include',
                                                                     'class_filter_array', array('cjw_newsletter_list'),
                                                                     'limitation', hash( ) )) }
                {if $newsletter_list_node_list|count|ne(0)}
                <div class="newsletter-system-design">
                    {*<h2>{$system_node.data_map.title.content|wash}</h2>*}
                    <table border="0" width="100%">

                    {foreach $newsletter_list_node_list as $list_node}
                        <tr>
                        {def $list_id = $list_node.contentobject_id
                             $confirmed = 0
                             $approved = 0
                             $removed = 0
                             $subscription = null
                             $list_selected_output_format_array = array()
                             $status = 0
                             $is_removed = true()
                             $subscription_hash = ''
                             $td_counter = 0}


                        {if is_set( $subscription_array[ $list_id ] )}
                            {set $subscription = $subscription_array[ $list_id ]
                                 $list_selected_output_format_array = $subscription.output_format_array
                                 $confirmed = $subscription.confirmed
                                 $removed = $subscription.removed
                                 $approved = $subscription.approved
                                 $status = $subscription.status
                                 $is_removed = $subscription.is_removed
                                 $subscription_hash = $subscription.hash}

                        {/if}

                        {def $list_output_format_array = $list_node.data_map.newsletter_list.content.output_format_array}

                        {if $list_output_format_array|count|ne(0)}
                            <td>
                                {*<li>status: ({$status|wash}) - confirmed( {if $confirmed|ne(0)} {$confirmed|datetime( 'custom', '%j.%m.%Y %H:%i' )}{else} n/a {/if}) | approved({if $approved|ne(0)}  {$approved|datetime( 'custom', '%j.%m.%Y %H:%i' )} {else} n/a {/if}) | removed({if $removed|ne(0)}  {$removed|datetime( 'custom', '%j.%m.%Y %H:%i' )} {else} n/a {/if})<br>*}
                                <input type="hidden" name="Subscription_IdArray[]" value="{$list_id}" title="" />
                                <input type="checkbox" name="Subscription_ListArray[]" value="{$list_id}"{if and( $is_removed|not , is_set( $subscription_array[ $list_id ] ) )} checked="checked"{/if} title="{$list_node.data_map.title.content|wash}" /> {$list_node.data_map.title.content|wash}
                                {*$list_node.data_map.newsletter_list|attribute(show)*}
                            </td>
                            {if $list_output_format_array|count|gt(1)}

                                {foreach $list_output_format_array as $output_format_id => $output_format_name}

                                    <td class="newsletter-list">
                                    <input type="radio" name="Subscription_OutputFormatArray_{$list_id}[]" value="{$output_format_id|wash}" {if is_set( $list_selected_output_format_array[ $output_format_id ] )} checked="checked"{/if} title="{$output_format_name|wash}" /> {$output_format_name|wash}</td>
                                    {set $td_counter = $td_counter|inc}
                                {/foreach}

                            {else}

                                {foreach $list_output_format_array as $output_format_id => $output_format_name}
                                    <td class="newsletter-list">&nbsp;<input type="hidden" name="Subscription_OutputFormatArray_{$list_id}[]" value="{$output_format_id|wash}" title="{$output_format_name|wash}" /></td>
                                    {set $td_counter = $td_counter|inc}
                                {/foreach}

                            {/if}

                            {*if $subscription_hash|ne('')}
                                <a href={concat('newsletter/unsubscribe/', $subscription_hash )|ezurl()}>unsubscribeDirektLink</a>
                            {/if*}
                        {/if}

                        {* create missing td *}
                        {while $td_counter|lt( $available_output_formats )}
                        <td>&nbsp;{*$td_counter} < {$available_output_formats*}</td>
                        {set $td_counter = $td_counter|inc}
                        {/while}

                        {undef $list_output_format_array
                               $list_id
                               $confirmed
                               $approved
                               $removed
                               $subscription
                               $list_selected_output_format_array
                               $status
                               $is_removed
                               $subscription_hash
                               $td_counter}
                        </tr>
                    {/foreach}
                    </table>
                </div>
                {/if}
                {undef $newsletter_list_node_list}

                {/foreach}
{*
                <input class="halfbox" id="Subscription_Email" type="text" name="Subscription_Email" value="{$newsletter_user.email|wash}" title="{'Email of the subscriber.'|i18n( 'cjw_newsletter/datatype/cjwnewslettersubscription' )}" {cond( is_set( $newsletter_user ), 'disabled="disabled"', '')} />
*}
        {/if}
        {undef $newsletter_available}
    {/if}

{undef $attribute_base
       $attribute_content
       $newsletter_user
       $subscription_array}

{*$attribute.object.data_map|attribute(show)*}



{*{default attribute_base=ContentObjectAttribute}
{let data_text=cond( is_set( $#collection_attributes[$attribute.id] ), $#collection_attributes[$attribute.id].data_text, $attribute.content )}
<input class="box" type="text" size="20" name="{$attribute_base}_data_text_{$attribute.id}" value="{$data_text|wash( xhtml )}" />
{/let}
{/default}*}