d=2021-07-15
t=
ps=50
pn=1
s=7s
l=100

while [[ $d != $(date -I) ]]; do 
    di=$d
    df=$(date -I -d "$d +1 day")

    while true; do

        sleep $s
        
        curl --location -g -s \
        --request GET "https://app.hugme.com.br/api/ticket/v1/tickets?last_modification_date[gte]=${di}&last_modification_date[lt]=${df}&page[size]=${ps}&page[number]=${pn}&sort[id]=ASC" \
        --header "Accept: application/json" \
        --header "Authorization: Bearer $t" \
        --output /home/danilo/Documents/hugme/retrieve_all_tickets/$(date -d $d +"%Y")/$(date -d $d +"%m")/$(date -d $d +"%d")/$pn.json --create-dirs

        nc=$(wc -m < /home/danilo/Documents/hugme/retrieve_all_tickets/$(date -d $d +"%Y")/$(date -d $d +"%m")/$(date -d $d +"%d")/$pn.json)
        if [[ $nc -lt $l ]]; then
            rm /home/danilo/Documents/hugme/retrieve_all_tickets/$(date -d $d +"%Y")/$(date -d $d +"%m")/$(date -d $d +"%d")/$pn.json
            break
        fi

        ((pn++))
    done
    pn=1
    d=$(date -I -d "$d +1 day")
done
