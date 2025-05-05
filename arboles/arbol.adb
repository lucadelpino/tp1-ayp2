with Unchecked_Deallocation,cola;

package body arbol is

   procedure free is new Unchecked_Deallocation (tiponodo,tipoArbol);

   procedure crear (a:out tipoArbol) is
   begin
      a:=null;
   end crear;


   procedure insertar (a : in out tipoArbol; k : in tipoClave ; i : in tipoInfo)is
   begin
      if (a = null) then		-- CB: éxito
        a := new tipoNodo;
        a.all.clave := k;
        a.all.info := i;
        a.all.hijoIzq := null;
        a.all.hijoDer := null;
      else
        if (k = a.all.clave) then		-- CB: falla
         raise claveExiste;
        else
         if (k < a.all.clave) then
            insertar(a.all.hijoIzq,k,i);
         else
            insertar(a.all.hijoDer,k,i);
         end if;
        end if;
      end if;
   exception
      when STORAGE_ERROR => raise ArbolLleno;
         -- Fe de erratas clase 21/4:
         -- STORAGE_ERROR es lanzada cuando new no tiene memoria disponible.
   end insertar;


   procedure buscarMenor (ab: in tipoArbol; claveM: out tipoClave;infoM: out tipoInfo) is
	a:tipoArbol;
   begin
      a := ab;
      while a.hijoIzq /= null loop
         a:=a.hijoIzq;
      end loop;
      claveM:=a.clave;
      infoM:=a.info;
   end buscarMenor;


   procedure suprimir (a: in out tipoArbol; k: in tipoClave) is
      aux:tipoArbol;
      clave: tipoclave;
      info: tipoInfo;
   begin
      if a=null then
         raise claveNoExiste;
      else
         if a.clave=k then
            if a.hijoIzq=null and a.hijoDer=null then -- Hoja
               free(a);
               a:=null;
            else
               if a.hijoIzq/=null and a.hijoDer=null then -- Unico subarbol
                  aux:=a;
                  a:=a.hijoIzq;
                  free(aux);
               else
                  if a.hijoIzq=null and a.hijoDer/=null then -- Unico subarbol
                     aux:=a;
                     a:=a.hijoDer;
                     free(aux);
                  else
                     buscarMenor(a.hijoDer,clave,info); -- Dos subarboles
                     a.info:=info;
                     a.clave:=clave;
                     suprimir(a.hijoDer, clave);
                  end if;
               end if;
            end if;
         else
            if a.clave>k then
               suprimir(a.hijoIzq, k);
            else
               suprimir(a.hijoDer, k);
            end if;
         end if;
      end if;
   end suprimir;


   procedure buscar (a : in tipoArbol ; k : in tipoClave ; i : out tipoInfo) is
   begin
      	if (a = null) then		-- CB: falla --
         raise claveNoExiste;
       else
         if (k = a.all.clave) then		-- CB: éxito --
            i := a.all.info;
         else
            if (k < a.all.clave) then
               buscar(a.all.hijoIzq,k,i);
            else
               buscar(a.all.hijoDer,k,i);
			  end if;
		  end if;
	   end if;
   end buscar;


   procedure modificar (a : in out tipoArbol; k : in tipoClave ; i : in tipoInfo)is
   begin
      if (a=null) then
         raise ClaveNoExiste;
      else
         if (a.clave=k)then
            a.info:=i;
         else
            if (k<a.clave) then
               modificar(a.hijoIzq,k,i);
            else
               modificar(a.hijoDer,k,i);
            end if;
         end if;
      end if;
   end modificar;



   procedure vaciar (a : in out tipoArbol) is
   begin
      if (a /= null) then
         vaciar(a.all.hijoIzq);
         vaciar(a.all.hijoDer);
         free(a);
         a:=null;
      end if;
   end vaciar;


   function esVacio(a:in tipoarbol)return boolean is
   begin
        return (a = null);
   end esVacio;

   procedure preOrder(a:in tipoarbol; q:in out tipoCola)is
   begin
      if (a /= null) then
        encolar(q,a.all.clave);
        PreOrder(a.all.hijoIzq,q);
        PreOrder(a.all.hijoDer,q);
      end if;
   exception
         when colaLlena => raise errorEnCola;
   end preOrder;

   procedure postOrder(a:in tipoarbol; q:in out tipoCola)is
   begin
      if (a /= null) then
        PostOrder(a.all.hijoIzq,q);
        PostOrder(a.all.hijoDer,q);
        encolar(q,a.all.clave);
      end if;
   exception
          when colaLlena => raise errorEnCola;
   end postOrder;

   procedure inOrder(a:in tipoarbol; q:in out tipoCola)is
   begin
      if (a/=null)then
         inOrder(a.hijoIzq, q);
         Encolar(q,a.clave);
         inOrder(a.hijoDer, q);
      end if;
   exception
      when colaLlena => raise ErrorEnCola;
   end inOrder;
end arbol;
