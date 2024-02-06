/*
 * paging_helpers.c
 *
 *  Created on: Sep 30, 2022
 *      Author: HP
 */
#include "memory_manager.h"

/*[2.1] PAGE TABLE ENTRIES MANIPULATION */
inline void pt_set_page_permissions(uint32* page_directory, uint32 virtual_address, uint32 permissions_to_set, uint32 permissions_to_clear)
{
	uint32 *ptr_page_table =NULL;
		int ret= get_page_table(page_directory,virtual_address,&ptr_page_table);
		if(ret==TABLE_NOT_EXIST)
		{
			panic("Invalid va");
		}
		else
		{

			ptr_page_table[PTX(virtual_address)]|= permissions_to_set;
			ptr_page_table[PTX(virtual_address)]&= ~permissions_to_clear;
			tlb_invalidate((void *)NULL,(void *)virtual_address);
		}
}

inline int pt_get_page_permissions(uint32* page_directory, uint32 virtual_address )
{
	uint32 *ptr_page_table=NULL;
		int ret=get_page_table(page_directory,virtual_address,& ptr_page_table);
		if(ptr_page_table !=NULL)
		{
			uint32 entry=ptr_page_table[PTX(virtual_address)];
			uint32 permissions=entry<<20;
			permissions=permissions>>20;

			return permissions;
		}
		else
			return -1;
}


inline void pt_clear_page_table_entry(uint32* page_directory, uint32 virtual_address)
{

	uint32 directory_entry = ptr_page_directory[PDX(virtual_address)];
	uint32 *ptr_page_table = NULL;
	int ret = get_page_table(ptr_page_directory, virtual_address, &ptr_page_table);
	if (ret == TABLE_IN_MEMORY)
	{
		ptr_page_table[PTX(virtual_address)] &=0;
		tlb_invalidate((void *)NULL, (void *)virtual_address);

	}
	else
	{
		panic("Invalid va");
	}

}

/***********************************************************************************************/

/*[2.2] ADDRESS CONVERTION*/
inline int virtual_to_physical(uint32* page_directory, uint32 virtual_address)
{
	uint32 *ptr_page_table=NULL;
    int ret=get_page_table(page_directory,virtual_address,&ptr_page_table);
    if(ptr_page_table !=NULL)
    {
    	uint32 entry_page=ptr_page_table[PTX(virtual_address)];
    	int framenum=entry_page >> 12;
    	uint32 physical_address=framenum*PAGE_SIZE;
    	return physical_address;


    }
    else
    	return -1;
}

/***********************************************************************************************/

/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/

///============================================================================================
/// Dealing with page directory entry flags

inline uint32 pd_is_table_used(uint32* page_directory, uint32 virtual_address)
{
	return ( (page_directory[PDX(virtual_address)] & PERM_USED) == PERM_USED ? 1 : 0);
}

inline void pd_set_table_unused(uint32* page_directory, uint32 virtual_address)
{
	page_directory[PDX(virtual_address)] &= (~PERM_USED);
	tlb_invalidate((void *)NULL, (void *)virtual_address);
}

inline void pd_clear_page_dir_entry(uint32* page_directory, uint32 virtual_address)
{
	page_directory[PDX(virtual_address)] = 0 ;
	tlbflush();
}
